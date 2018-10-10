+++
author = "hannibal"
categories = ["Golang", "Furnace"]
date = "2018-09-18T07:01:00+01:00"
type = "post"
title = "HashiCorp go-plugin tutorial"
url = "/2018/09/18/go-plugin-tutorial"
description = "HashiCorp Go-plugin tutorial"
featured = "plugin-tutorial.png"
featuredalt = "plugin"
featuredpath = "date"
linktitle = ""
draft = true
+++

Hi.

Today we are going to explore the plugin system of HashiCorp called [go-plugin](http://github.com/hashicorp/go-plugin).

Let's get to it then.

# Intro

If you don't know what go-plugin is, don't worry. I'll give a small introduction on the subject matter.

Back in the old days when go didn't have the `plugin` package, HashiCorp was desperatly looking for a way to use plugins in Go.

In the old days, Lua plus Go wasn't really a thing yet, and to be honest, nobody wants to write Lua ( joking! ).

And thus Mitchell had this brilliant idea of using RPC over the local network to server a local interface as something that could easily be implemented with any other language that supported RPC. This sounds convoluted but has the benefit that plugins will never crash your system, as I already mentioned, it also gives the plugin author the opportunity of using ANY language. And not just Go to write a plugin.

This has been battle prooven for years, since Terraform, Vault, Consule and especially Packer are all using go-plugin in order to provide a much needed flexibility for these tools. Writing a plugin is easy. Or so they say.

It can get pretty complicated quickly if you are trying to use GRPC for example. You can loose sight of what exactly you'll need to implement and where and why? Or, utilizing various languages or using go-plugins in your own project and extending your CLI with pluggable components.

These are all nothing to sneeze at. Suddenly, you'll find yourself with hundreds of lines of
code pasted from various examples and yet nothing works. Or worse, it DOES work, but you have no idea how? And find
yourself that you need to extend it with a new capability or find an ellusive bug and can't trace it's origins.

But fear not. I'll try to demistify things and draw a good picture about how this works and {where,how} the pieces fit together.

Let's start at the beginning. I'm going to use GRPC in these examples.

# Basic plugin

Let's start by writing a simple Go GRPC plugin. In fact we can go through the Basic example in the go-plugin repository which can be quiet confusing when you first start out. But we'll go step by step and the switch to GRPC will be easier.

## Basic concepts

### Server

In case of the plugins the Server is the one serving the plugin's implementation. Which means that the server will have to provide the implementation to a protoc defined interface.

### Client

The Client calls the server in order to execute the desired behaviour. The underlying framework will connect to the server and call the defined function and will wait for a response.

## Implementation

### The main function

#### Logger

The plugins defined here use stdout in a special way. In fact, if you aren't writing a Go based plugin you will have to do that yourself by outputting something like this.

~~~
1|1|tcp|127.0.0.1:1234|grpc
~~~

We'll come back to this later. Sufice to say, that the framework will pick this up and connect to the plugin based on this output.

#### NewClient

![newclient](/img/go-plugin/new_client.png)

What is happening here? Let's see one by one.

`HandshakeConfig: handshakeConfig,`: This part is the handshake configuration of the plugin. This part of the code has a nice comment as well.

![handshake](/img/go-plugin/handshake.png)

The `ProtocolVersion` here is used in order to maintain compatibility with your current plugin versions. It's basically like an API version. If you increase this, you have two options. Don't accept lower protocol versions or switch on the version number and use a different client implementation for a lower version than for a higher version.

This way you will keep backwards compatibility.

The `MagicCookieKey` and `MagicCookieValue` are used for a basic handshake which the comment is talking about. You have to set this **ONCE** for your application and then never change it ever again. Because if you do, your plugins will no longer work. I suggest using a UUID here for uniquness sake.

The `Cmd` here is the key. Basically how plugins work is, that they boil down to a compiled binary which is executed and serves an RPC server. This is where you will have to define the binary which will be executed. Since this is all happening locally (keep in mind that go-plugins only support localhost and for a good reason) these binaries will most likely sit next to your application's binary or in a pre-configured global location. Something like `~/.config/my-app/plugins`. This is individual for each plugin of course. Lator on upon discovery we will see how to set this dynamically.

And last but not least is the `Plugins` map. This map is used in order to identify a plugin to call by dispense. This map is globally available and must stay consistent in order for all the plugins to work. This map will be used like this:

![pluginmap](/img/go-plugin/plugin_map.png)

You can see that the key is the name of the plugin and the value is the plugin.

We then proceed to create an RPC client.

![rpcclient](/img/go-plugin/rpc_client.png)

Nothing fancy about this one...

Now comes the interesting part.

![dispense](/img/go-plugin/dispense.png)

What's happening here? Dispense will look in the above created map and search for the plugin. If it cannot find it it will throw and error at us. If it does find it, it will cast this plugin to an RPC or a GRPC type plugin. Then proceeds to create an RPC or a GRPC client out of it.

There is no call yet. This is just creating a client and parsing it to a respective representation.

Now comes the magic:

![rawtypeassert](/img/go-plugin/raw_type_assert.png)

Here, we are type asserting our raw GRPC client into our own plugin type. This is so we can call the respective function on the plugin! Once that's done we will have a {client,struct,implementation} that can be called like a simple function.

The implementation right now comes from greeter_impl.go, but that will change once protoc makes the scene.

This concludes main.go for now.
