---
title: Kubernetes distributed application deployment with sample Face Recognition App
author: hannibal
layout: post
date: 2018-03-15T23:01:00+01:00
url: /2018/03/15/kubernetes-distributed-application
categories:
  - Go
  - Kubernetes
  - FaceRecognition
draft: true
---
# Intro

Alright folks. Settle in. This is going to be a long, but hopefully, fun ride.

I'm going to deploy a distributed application with [Kubernetes](https://kubernetes.io/). I was trying to create an application which I thought resembles a real world app as close as possible. But obviously I cut some corners because of time and energy constraints.

My focus will be on Kubernetes and deployment rather than the structure and best practices of a distributed application. That said, I did try to aim at not doing anything too stupid.

Shall we?

# The Application

## TL;DR

The application itself consists of three apps and three services. The repository can be found here: [Kube Cluster Sample](https://github.com/Skarlso/kube-cluster-sample).

It is a face recognition service which identifies images of people, comparing them to known individuals. A simple front-end displays a table of these images and what people they belong to. This happens by sending a request to the [receiver](https://github.com/Skarlso/kube-cluster-sample/tree/master/receiver). The request contains a path to an image. The image could sit on an NFS somewhere. The receiver stores this path in the DB (MySQL) and sends a processing request to a queue. The queue uses [NSQ](http://nsq.io/). The request contains the ID of the saved image.

An [Image Processing](https://github.com/Skarlso/kube-cluster-sample/tree/master/image_processor) service is constantly monitoring the queue for jobs to do. It picks off the items on the queue and processes them via Go routines. The processing consists of taking the ID, loading in the image and sending off the path to the image to a [face recognition](https://github.com/Skarlso/kube-cluster-sample/tree/master/face_recognition) back-end written in Python via [gRPC](https://grpc.io/). The back-end identifies the person on the image, marks the image as processed and this is where it all ends.

You may wonder that if there is no back-feed on the processing, what's the point of the async behavior? Well, it is possible for a large building to want a history of people entering, leaving and generally being in the vicinity. They don't require this information immediately so speed is not of the essence. However, robustness is so they want a fault tolerant application which can handle possibly millions of images being sent of for processing. The turn-around time of a single image being processed on my potato is under 3 seconds.

The images are stored, processed, than flagged. Failed images can be re-tried with a cron job for example.

TODO: Insert gif here

So how does this all work? Let's dive in.

## Receiver

The receiver service is the starting point of the process. The receiver is an API which receives a request in the following format:

~~~bash
curl -d '{"path":"nfs://images/unknown.jpg"}' http://127.0.0.1:8000/image/post
~~~

In this moment, receiver stores this path using a shared database cluster. The entity then will receive an ID from the database service. This application is based on the model where unique identification for Entity Objects is provided by the persistence layer. Once the ID is acquired, receiver will send a message to the `NSQ`. The receiver's job is done at this point.

## Image Processor

Here is where the fun begins. When Image Processor first runs it creates two Go routines. These are...

### Consume

This is an NSQ consumer. It has two jobs. First, it listens for messages on the queue. Second, when there is a message it appends the received ID to a thread safe slice of IDs that the second routine processes. Lastly it signals the second routine that there is work to do. It does that through [sync.Condition](https://golang.org/pkg/sync/#Cond).

### ProcessImages

This routine processes a slice of IDs until the slice is drained completely. Once the slice is drained the routine goes into suspend instead of sleep waiting on a channel. The processing of a signle ID is through the following steps in order:

* Establish a gRPC connection to the Face Recognition service (explained under Face Recognition)
* Retrieve the image record from the database
* Setup two functions for the [Circuit Breaker](#circuit-breaker)
  * Function 1: The main function which does the RPC method call
  * Function 2: A health check for the Ping of the circuit breaker
* Call Function 1 which sends the path of the image to the face recognition service. This path should be accessible.Preferably something shared, like an NFS
* If this call fails, update the image record as FAILEDPROCESSING
* If it succeeds, an image name should come back which corresponds to a person in the db. It runs a Joined SQL query which gets the corresponding person's id
* It then proceeds to update the Image record in the database with PROCESSED status and the ID of the person that image was identified as

And this is it. This service can be replicated, meaning, more than one could run of it at any given time without problems.

### Circuit Breaker

So, in a system where replicating resources requires little time, there still could be cases where, for example, the network goes down, or there are communication problems of any kind between two services. I though for fun, I implement a little circuit breaker around the gRPC calls.

This is how it works basically:

TODO: Insert nice gif here.

As you can see, once there are 5 unsuccessful calls to the service the circute breaker activates and doesn't allow any more calls to go through. After a configured amount of time, it will send a Ping call to the service to see if it's back up. If that still errors out, it increases the timeout. If not, it allows the remaining calls to happen.

## Front-End

This is only a simplistic table view with Go's own html/template used to render a list of images.

## Face Recognition

Here is where the identification magic is happening. I decided to make this a gRPC based service for a sole purpose of flexibility. I started writing it in Go, but decided that a Python implementation could be much sorter. In fact, not counting the gRPC code the recognition part is about 7 lines of Python code. I'm using this fantastic library which has all the C bindings going to OpenCV so I didn't had to implement those. [Face Recognition](https://github.com/ageitgey/face_recognition). Having an API contract here means that I can exchange the implementation any time as long as it receives and sends the same thing.

Note that there is a great Go library that I was about to use, but they have yet to write the C binding for that part of OpenCV. It's called [GoCV](https://gocv.io/). Go, check them out. They have some pretty amazing things, like real time camera feed processing with only a couple of lines of Go.

How to library works is simple in nature. Have a set of images about people you know and have a record for. In this case, I have a folder with a couple of images named, `hannibal_1.jpg, hannibal_2.jpg, gergely_1.jpg, john_doe.jpg`. In the database I have two tables named, `person, person_images`. They look like this:

~~~bash
+----+----------+
| id | name     |
+----+----------+
|  1 | Gergely  |
|  2 | John Doe |
|  3 | Hannibal |
+----+----------+
+----+----------------+-----------+
| id | image_name     | person_id |
+----+----------------+-----------+
|  1 | hannibal_1.jpg |         3 |
|  2 | hannibal_2.jpg |         3 |
+----+----------------+-----------+
~~~

The face recognition library returns the name of the image the unknown image matches to. After that a simple joined query like this will return the person in question.

~~~sql
select person.name, person.id from person inner join person_images as pi on person.id = pi.person_id where image_name = 'hannibal_2.jpg';
~~~

The gRPC call return the id of the person which is than used to update the image's `person` column.

## NSQ

NSQ is a nice little Go based queue. It can be scaled and has a minimal footprint on the system. It has a lookup service which consumers use to receive messages and a daemon that senders use to send messages.

TODO: Insert gif here

NSQ's philosophy is that the daemon should run with the sender application. That way, the sender sends to localhost only. But the daemon is connected to the lookup service and that's how they achieve a global queue.

This means that there are as many NSQ daemons deployed as there are senders. Because the daemon has a minuscule resource requirement, it won't interfere with the requirements of the main application.

## Configuration

In order to be as flexible as possible and making use of Kubernetes' ConfigSet, I'm using .env files to store configuration like the location of the database service or NSQ's lookup address in dev stages. In production, and that means the Kubernetes environment, I'll use environment properties to set up configuration.

## Conclusion for the Application

And that's all there is to the architecture of the application we are about to deploy. All of its components are changeable and only coupled through the database a queue and gRPC. This is imperative when deploying a distributed application because of how updating mechanics work. I will cover that part in the Deployment section.

For now, the important part is that all the components can be scaled and that they don't step on each other while working on the same image for example.

# Deployment with Kubernetes

## Basics

So, what **is** Kubernetes?

I'll cover some basics here, although I won't go too much into details as that would require a whole book like this one: [Kubernetes Up And Running](http://shop.oreilly.com/product/0636920043874.do). Also, you can look at the documentation if you are daring enough: [Kubernetes Documentation](https://kubernetes.io/docs/).

Kubernetes is a containerized service and application manager. It scales easily, employs a swarm of containers but more importantly, it's highly configurable via yaml based template files. People compare Kubernetes to Docker swarm, but Kubernetes does way more than that. Not to mention the fact that it's container agnostic. So, you could use LXC with Kubernetes for example. It provides a layer above managing a cluster of deployed services and applications. How? Let's take a quick look at the building blocks of Kubernetes.

In Kubernetes you describe a desired state of the application and Kubernetes will do what it can to reach that state. States could be for example, deployed, paused, replicated 2 times and so and so forth.

One of the basics of Kubernetes is that it uses Labels and Annotations for everything. Services, deployments, replicasets, everything is labeled. Don't remove or mess with these because, for example, if you have deployment that desires a replicates of 2 of an application and you remove the label from one of the containers, that container will get orphaned and the ReplicaSet will create a new one since now it only detects one as the desired capacity.

### Nodes

A Node is a worker machine. A node can be anything from a vm to a physical machine, including all sorts of cloud provided vms.

### Pods

Pods are a logically grouped collection of containers. That means, one Pod can potentially house a multitude of containers. A Pod gets its own DNS and virtual IP address after it has been created so Kubernetes can load balancer traffic to it. You rarely have to deal with containers directly. Even when debugging, like looking at logs, you usually invoke something like `kubectl logs deployment/your-app -f` instead of looking at a specific container. Although it is possible. The `-f` does a tail on the log.

### Deployments

When creating any kind of resource in Kubernetes, it will use something called a Deployment in the background. A deployment describes a desired state of the current application. It's an object you can use to update some Pods or a Service to be in a different state. Do an update, or a rollout of some kind, or create another application or a service. For example you don't directly conrtol a ReplicaSet (described later) but control the deployment object which creates and manages a ReplicaSet.

### Services

By default a Pod will get an IP address. However, since Pods are a volatile thing in Kubernetes you'll need something more permanent if you wish to have a running API for example. Things like services, for example: a queue, mysql, an internal API, a frontend; need to be long running and behind a static, unchanging IP or DNS record.

For this purpose, Kubernetes has Services for which you can define modes of accessibility. For example, Load Balanced, simple IP or internal DNS.

How does Kubernetes know if a service is running correctly? You can configure Health Checks and Availability Checks. A HealtCheck will check if a container is running but that doesn't mean that your service is successful. For that, you have the availability check which pings a different endpoint in your application.

### DNS / Service Discovery

If you create a service in the cluster that service will get a DNS record in Kubernetes provided by special Kubernetes deployments called kube-proxy and kube-dns. These two provide service discover inside a cluster. So if you have a mysql service running, than everyone in the cluster can reach that service by pinging `mysql.default.svc.cluster.local`. Where:

* `mysql` -- is the name of the service
* `default` -- is the namespace name
* `svc` -- is services
* `cluster.local` -- is a local cluster domain

The domain can be changed by using a custom DNS definition. From the outside a DNS provider has to be used an Nginx for example to bind an IP address to a record. The public IP address of a service can be queried with the following commands:

* NodePort -- `kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services mysql`
* LoadBalancer -- `kubectl get -o jsonpath="{.spec.ports[0].LoadBalancer}" services mysql`

### Template Files

Like Docker Compose, or TerraForm or other service management tools, Kubernetes also provides infrastructure describing templates. What that means is that you rarely have to do anything by hand.

For example consider the following yaml template which describes an nginx Deployment:

~~~yaml
apiVersion: apps/v1
kind: Deployment #(1)
metadata: #(2)
  name: nginx-deployment
  labels: #(3)
    app: nginx
spec: #(4)
  replicas: 3 #(5)
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers: #(6)
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
~~~

This is a simple deployment where we do the following:

* (1) Define the type of the template with kind
* (2) Add metadata that will identify this deployment and every resource that it would create with a label (3)
* (4) Then comes the spec which describes the desired state
  * (5) For the nginx app have 3 replicas
  * (6) This is the template definition for the containers that this Pod will contain
    * nginx named container
    * nginx:1.7.9 image (docker in this case)
    * exposed ports

### ReplicaSet

A ReplicaSet is a low level replication manager. It ensures that the correct number of replicates is running of a given Pod. However, Deployments are higher level and should always manage replicasets. You rarely have to use ReplicaSets directly. Unless you have a fringe case where you want to control the specifics of replication.

### DaemonSet

So remember how I said Kubernetes is using Labels all the time? A DaemonSet is a controller that ensures that at any given time a given daemonized application is always running for a congiured Node.

For example, you have a node which is hosting a mysql service or you'd like every node that is tagged as `logger` or `mission_critical` to run an auditing service / logger daemon. Then you create a daemonset and give it a node selector called `logger` or `mission_critical`. Which will look for a node that has that given label and always ensure that if a node exists it will also have an instance of that daemon running in it. Thus everyone running on that node will have access to that daemon locally.

It does more than that though. The DaemonSet has all the benefits of the ReplicaSet. Meaning it's scalable and you'll get the benefit of Kubernetes managing it. Which means, if it dies, it will get re-created.

### Scaling

In Kubernetes it's trivial to scale. The ReplicaSets take care of the number of instances of a Pod to run. Like you saw in the nginx deployment with the setting `replicas:3`. It's up to us to write our application in a way that it allows Kubernetes to run multiple copies of it.

### Conclusion for Kubernetes

It's a convenient tool to handle container orchestration. Its unit of work are Pods and it has a layered architecture. The top level layer is Deployments through which you handle all other resources. It's highly configurable. It provides an API for all calls you make, so potentionally, instead of running `kubectl` you can also write your own logic to send information to the Kubernetes API.

It provides support for all major cloud providers natively by now and it's completely open source. Feel free to contribute, check the code if you would like to have a deeper understanding of how it works here: [Kubernetes on Github](https://github.com/kubernetes/kubernetes).

## Minikube

I'm going to use [Minikube](https://github.com/kubernetes/minikube/). Minikube is a local kubernetes cluster simulator. It's not great in simulating multiple nodes though, but for starting out and local play without any costs, it's great. It uses a VM that can be fine tuned if necessary using VirtualBox and the likes.

All the kube template files that I'll be using are located here: [Kube files](https://github.com/Skarlso/kube-cluster-sample/tree/master/kube_files).

## Building the containers

Kubernetes supports most of the containers out there. I'm going to use Docker. For all the services I've built, there is a Dockerfile included in the repository. I encourage you to study them. Most of them are simple. For the go services I'm using a multi stage build that got recently introduced. The Go services are Alpine Linux based. The Face Recognition service is Python. NSQ and MySQL are using their own Containers.

## Context

Kubernetes uses namespaces. If you don't specify any it will use the default namespace. I'm going to permanently set a context to avoid polluting the default namespace. You do that like this:

~~~bash
❯ kubectl config set-context kube-face-cluster --namespace=face
Context "kube-face-cluster" created.
~~~

You have to also start using the context once it's created like so:

~~~bash
❯ kubectl config use-context kube-face-cluster
Switched to context "kube-face-cluster".
~~~

After this, all `kubectl` commands will use the namespace `face`.

### MySQL

The first Service I'm going to deploy is my database. Since all the rest of the applications will be using it, it's paramount that it gets deployed first.

I'm using the Kubernetes example located here [Kube MySQL](https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/#deploy-mysql) which fits my needs. Note that this file is using a plain password for MYSQL_PASSWORD. Normally, you should use a vault, described here [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/). And than you'll use the env property like this:

~~~yaml
- name: SECRET_USERNAME
  valueFrom:
    secretKeyRef:
      name: mysecret
      key: username
~~~

I've created a secret locally as described in that document using a secret yaml:

~~~yaml
apiVersion: v1
kind: Secret
metadata:
  name: kube-face-secret
type: Opaque
data:
  mysql_password: base64codehere
~~~

And this is what you'll see in my deployment yaml file:

~~~yaml
...
- name: MYSQL_ROOT_PASSWORD
  valueFrom:
    secretKeyRef:
      name: kube-face-secret
      key: mysql_password
...
~~~

There is one other thing it does that we need to talk about. It uses a volume to persist the database. The volume definition looks like this:

~~~yaml
...
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
...
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim
...
~~~

`presistentVolumeClain` is the key here. It tells Kubernetes that this resource requires a persistent volume. How it's provided is abstracted away from the user. You can be sure the Kubernetes will provide you with a volume that will always be there. Similar to Pods. To read up on the details check out this document: [Kubernetes Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes).

Deploying the mysql Service is done with the following command:

~~~bash
kubectl apply -f mysql.yaml
~~~

`apply` and `create`. Create will create the service if it doesn't exists. But throws an error if it's already there. Apply will apply the template to the system. Meaning if you change the template it will apply the change. In this case, the change is that the service is not present in the first place, thus apply works in that it creates the service. Generally, if in doubt, use `apply`.

To see how it goes, run:

~~~bash
# Describes the whole process
kubectl describe deployment mysql
# Shows only the pod
kubectl get pods -l app=mysql
~~~

Output should be similar to this:

~~~bash
...
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   mysql-55cd6b9f47 (1/1 replicas created)
...
~~~

Or in case of get pods:

~~~bash
NAME                     READY     STATUS    RESTARTS   AGE
mysql-78dbbd9c49-k6sdv   1/1       Running   0          18s
~~~

To test the instance run the following snippet:

~~~bash
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -pyourpasswordhere
~~~

**GOTCHA**: If you change the password now, it's not enough to re-apply your yaml file to update the container. Since the DB is persisted, the password will not be changed. You have to delete the whole deployment with `kubectl delete -f mysql.yaml`.

You should see the following when running a `show databases`.

~~~bash
If you don't see a command prompt, try pressing enter.
mysql>
mysql>
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| kube               |
| mysql              |
| performance_schema |
+--------------------+
4 rows in set (0.00 sec)

mysql> exit
Bye
~~~

You'll notice that I also mounted a file located here [Database Setup SQL](https://github.com/Skarlso/kube-cluster-sample/blob/master/database_setup.sql) into the container. MySQL container automatically executed these. That file will bootstrap some data and the schema I'm going to use.

The volume definition is as follows:

~~~yaml
  volumeMounts:
  - name: mysql-persistent-storage
    mountPath: /var/lib/mysql
  - name: bootstrap-script
    mountPath: /docker-entrypoint-initdb.d/database_setup.sql
volumes:
- name: mysql-persistent-storage
  persistentVolumeClaim:
    claimName: mysql-pv-claim
- name: bootstrap-script
  hostPath:
    path: /Users/hannibal/golang/src/github.com/Skarlso/kube-cluster-sample/database_setup.sql
    type: File
~~~

To check if the bootstrap script was successful run this:

~~~bash
~/golang/src/github.com/Skarlso/kube-cluster-sample/kube_files master*
❯ kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -uroot -pyourpasswordhere kube
If you don't see a command prompt, try pressing enter.

mysql> show tables;
+----------------+
| Tables_in_kube |
+----------------+
| images         |
| person         |
| person_images  |
+----------------+
3 rows in set (0.00 sec)

mysql>
~~~

You should be able to see all the tables and gather some data with selects.

This concludes the database service setup. To see logs for this service run:

~~~bash
kubectl logs deployment/mysql -f
~~~

### NSQ Lookup

The NSQ Lookup will run as an internal service. It doesn't need access from the outside so I'm setting `clusterIP: None` which will tell Kubernetes not to assign an IP to it that's accessible.

Basically it's the same as MySQL just with slight modifications. As stated earlier, I'm using NSQ's own Docker Container called `nsqio/nsq`. It has everything it needs in one container. All the commands are there, so nsqd will also use this container just with a different `command`. For nsqlookupd the command is as follows:

~~~yaml
command: ["/nsqlookupd"]
args: ["--broadcast-address=nsqlookup.default.svc.cluster.local"]
~~~

So what's happening here? What's the `--broadcast-address` for? By default, nsqlookup will use the `hostname` as broadcast address. Meaning, when the consumer runs a callback it will try to connect to something like `http://nsqlookup-234kf-asdf:4161/lookup?topics=image` which will not work of course. By setting the broadcast-addres to the broadcasted internal DNS that callback will be `http://nsqlookup.default.svc.cluster.local:4161/lookup?topic=images`. Which will work as expected.

NSQ Lookup also requires two ports to be available. One for broadcasting and one for nsqd daemon callback. These are defined in the Dockerfile and in the kubernetes yaml file like this:

In the container template:

~~~yaml
        ports:
        - containerPort: 4160
          hostPort: 4160
        - containerPort: 4161
          hostPort: 4161
~~~

In the service template:

~~~yaml
spec:
  ports:
  - name: tcp
    protocol: TCP
    port: 4160
    targetPort: 4160
  - name: http
    protocol: TCP
    port: 4161
    targetPort: 4161
~~~

Names are required by kubernetes to distinguish between them. The full template file can be found here: [NSQLookupd Template](https://github.com/Skarlso/kube-cluster-sample/blob/master/kube_files/nsqlookup.yaml).

To create this service run the following command as before:

~~~bash
kubectl apply -f nsqlookup.yaml
~~~

This concludes the nsqlookupd service. And with that, we have two of the major players in the sack.

### Receiver

This is a tricky one. The receiver will run three things.

* It will create some deployments
* It will create the nsq daemon
* It will be public facing

#### Deployments

The first deployment it creates is it's own. The receiver container is `skarlso/kube-receiver-alpine`.

#### Nsq Daemon

The receiver starts an nsq daemon. Like said earlier, the receiver runs an nsq with it-self. It does that so talking to it can happen locally and not over the network. By making receiver do this, it will end up on the same node as the receiver and not on a different one.

NSQ daemon also needs some adjustments and parameters.

~~~yaml
        ports:
        - containerPort: 4150
          hostPort: 4150
        - containerPort: 4151
          hostPort: 4151
        env:
        - name: NSQLOOKUP_ADDRESS
          value: nsqlookup.default.svc.cluster.local
        - name: NSQ_BROADCAST_ADDRESS
          value: nsqd.default.svc.cluster.local
        command: ["/nsqd"]
        args: ["--lookupd-tcp-address=$(NSQLOOKUP_ADDRESS):4160", "--broadcast-address=$(NSQ_BROADCAST_ADDRESS)"]

~~~

You can see the lookup-tcp-address and the broadcast-address are set. Lookup tcp address is the DNS for the nsqlookupd service. And the broadcast address is necessary just like with nsqlookupd so the callbacks are working properly.

#### Public facing

Now, this is the first time I'm dpeloying a public facing interface. There are two options. I could use a LoadBalancer, because this API will be under heavy load. And if this would be deployed anywhere in production, than it should be a LoadBalancer. I'm doing local this locally though so something called a `NodePort` is enough. A `NodePort` simply opens a forwarded port for a service. If not specified, it will assign a random port on the host between 30000-32767. But it can also be configured to be a specific port, using `nodePort` in the yaml. For now, I'm just leaving it at default.

For further information check out the node port documentation located here: [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport).

Putting this all together, we'll get a receiver-service for which the template is as follows:

~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: receiver-service
spec:
  ports:
  - protocol: TCP
    port: 8000
    targetPort: 8000
  selector:
    app: receiver
  type: NodePort
~~~

For a fixed nodePort on 8000 for example, a definition of `nodePort` must be provided as follows:

~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: receiver-service
spec:
  ports:
  - protocol: TCP
    port: 8000
    targetPort: 8000
  selector:
    app: receiver
  type: NodePort
  nodePort: 8000
~~~

### Image processor

The Image Processor is where I'm handling passing of images to be identified. This is not a public facing API but should have access to nsqlookupd, mysql and the gRPC endpoint of the face recognition service deployed later. This is actually a boring service. In fact, it's not a service at all. It doesn't expose anything and thus it's the first deployment only template file. For brevity, here is the whole template:

~~~yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: image-processor-deployment
spec:
  selector:
    matchLabels:
      app: image-processor
  replicas: 1
  template:
    metadata:
      labels:
        app: image-processor
    spec:
      containers:
      - name: image-processor
        image: skarlso/kube-processor-alpine:latest
        env:
        - name: MYSQL_CONNECTION
          value: "mysql.default.svc.cluster.local"
        - name: MYSQL_USERPASSWORD
          valueFrom:
            secretKeyRef:
              name: kube-face-secret
              key: mysql_userpassword
        - name: MYSQL_PORT
          # TIL: If this is 3306 kubectl throws an error.
          value: "3306"
        - name: MYSQL_DBNAME
          value: kube
        - name: NSQ_LOOKUP_ADDRESS
          value: "nsqlookup.default.svc.cluster.local:4161"
        - name: GRPC_ADDRESS
          value: "face-recog.default.svc.cluster.local:50051"

~~~

The only interesting point in this file are the multitude of environment properties that are used to configure the application. Note the nsqlookupd address and the grpc address.

To create this deployment run:

~~~bash
kubectl apply -f image_processor.yaml
~~~

### Face - Recognition

The face recognition service does have a service. It's a boring one, only reachable by image-processor. It's definition looks as follows:

~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: face-recog
spec:
  ports:
  - protocol: TCP
    port: 50051
    targetPort: 50051
  selector:
    app: face-recog
  clusterIP: None
~~~

The more interesting part is that it requires two volumes. The two volumes are `known_people` and `unknown_people`. Can you guess what will be in these volumes? Yep, images. The `known_people` volume contains all the images associated to the known people in the database. The `unknown_people` volume will contain all the new images. And that's the path we will need to use when sending images from the receiver. Basically the path needs to be one that the face recognition service can access.

Now, with Kubernetes and Docker this is easy. It could be a mounted S3 or some kind of nfs or a local mount. I'm going to use a local one for the sake of simplicity.

Mounting a volume has two parts. First, the Dockerfile:

~~~Dockerfile
VOLUME [ "/unknown_people", "/known_people" ]
~~~

Second, add it to the Kubernetes template config file as seen earlier with MySQL:

~~~yaml
        volumeMounts:
        - name: known-people-storage
          mountPath: /known_people
        - name: unknown-people-storage
          mountPath: /unknown_people
      volumes:
      - name: known-people-storage
        hostPath:
          path: /Users/hannibal/Temp/known_people
          type: Directory
      - name: unknown-people-storage
        hostPath:
          path: /Users/hannibal/Temp/
          type: Directory
~~~

We also have to set the known_people folder config setting for face recognition. This is done via an environment property of course:

~~~yaml
        env:
        - name: KNOWN_PEOPLE
          value: "/known_people"
~~~

Then the Python code will look up images like this:

~~~python
        known_people = os.getenv('KNOWN_PEOPLE', 'known_people')
        print("Known people images location is: %s" % known_people)
        images = self.image_files_in_folder(known_people)
~~~

Where `image_files_in_folder` is:

~~~python
    def image_files_in_folder(self, folder):
        return [os.path.join(folder, f) for f in os.listdir(folder) if re.match(r'.*\.(jpg|jpeg|png)', f, flags=re.I)]
~~~

Neat.

Now, if the receiver receives something like this...

~~~bash
curl -d '{"path":"/unknown_people/unknown220.jpg"}' http://192.168.99.100:30251/image/post
~~~

...it will look for an image called unknown220.jpg, locate an image in the known_folder that corresponds to the person on the unknown image and return an id of the person that matches that image name with an inner join select.

Looking at logs you should see something like this:

~~~bash
# Receiver
❯ curl -d '{"path":"/unknown_people/unknown219.jpg"}' http://192.168.99.100:30251/image/post
got path: {Path:/unknown_people/unknown219.jpg}
image saved with id: 4
image sent to nsq

# Image Processor
2018/03/26 18:11:21 INF    1 [images/ch] querying nsqlookupd http://nsqlookup.default.svc.cluster.local:4161/lookup?topic=images
2018/03/26 18:11:59 Got a message: 4
2018/03/26 18:11:59 Processing image id:  4
2018/03/26 18:12:00 got person:  Hannibal
2018/03/26 18:12:00 updating record with person id
2018/03/26 18:12:00 done
~~~

And that concludes all of the services that we need to deploy with Kubernetes to get this application to work.

### Frontend

Last but not least, there is a small web-app which displays the information in the db for convenience. This is also a public facing service with the same parameters as the receiver's public facing service.

It looks something like this:

![frontend](/img/kube-frontend.png)

### Recap

So what have we accomplished? We deployed a bunch of services all over the place. To recap on the commands executed, these are the ones in order:

~~~bash
kubectl create -f mysql.yaml
kubectl create -f nsqlookup.yaml
kubectl create -f receiver.yaml
kubectl create -f image_processor.yaml
kubectl create -f face_recognition.yaml
kubectl create -f frontend.yaml
~~~

These could be any order actually. The nsq consumer re-connects and so does the daemon. Query-ing kube for running pods with `kubectl get pods` you should see something like this:

~~~bash
❯ kubectl get pods
NAME                                          READY     STATUS    RESTARTS   AGE
face-recog-6bf449c6f-qg5tr                    1/1       Running   0          1m
image-processor-deployment-6467468c9d-cvx6m   1/1       Running   0          31s
mysql-7d667c75f4-bwghw                        1/1       Running   0          36s
nsqd-584954c44c-299dz                         1/1       Running   0          26s
nsqlookup-7f5bdfcb87-jkdl7                    1/1       Running   0          11s
receiver-deployment-5cb4797598-sf5ds          1/1       Running   0          26s
~~~

Running `minikube service list`:

~~~bash
❯ minikube service list
|-------------|----------------------|-----------------------------|
|  NAMESPACE  |         NAME         |             URL             |
|-------------|----------------------|-----------------------------|
| default     | face-recog           | No node port                |
| default     | kubernetes           | No node port                |
| default     | mysql                | No node port                |
| default     | nsqd                 | No node port                |
| default     | nsqlookup            | No node port                |
| default     | receiver-service     | http://192.168.99.100:30251 |
| kube-system | kube-dns             | No node port                |
| kube-system | kubernetes-dashboard | http://192.168.99.100:30000 |
|-------------|----------------------|-----------------------------|
~~~

So, this is quiet boring because there are no nodes and only 1 replica is running for each service. Lets spice things up.

### Rolling update

As it happens during software development, change is requested/needed to some parts of the application. What happens to our cluster if I would like to change one of it's components without breaking the other? And also whilest maintaining backwards compatibility and no disruption to user experience. Thankfully Kubernetes can help with that somewhat.

What I don't like right now is that the API only handles one image at a time. There is no option to bulk upload. Which, IMHO should be the default anyways.

### Scaling

If we set the ReplicaSet...

### Cleanup

~~~bash
kubectl delete deployments --all
kubectl delete services -all
~~~

