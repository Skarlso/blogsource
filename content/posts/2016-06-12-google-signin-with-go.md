---
title: How to do Google sign-in with Go
author: hannibal
layout: post
date: 2016-06-12
url: /2016/06/12/google-signin-with-go
categories:
  - Go
  - Golang
  - Web
---

Hi folks.

Today, I would like to write up a step - by - step guid with a sample web app on how to do Google assisted sign-in and user handling.

<!--more-->

Let's get started.

Setup
=====

Google OAuth token
------------------

First thing first, what you need is, to register your application with Google, so you'll get a Token that you can use for authentication purposes.

You can do there here -> [Google Developer Console](https://console.developers.google.com/iam-admin/projects). You'll have to create a new project. Once it's done, click on ```Credentials``` and create an OAuth token. You should see something like this -> "To create an OAuth client ID, you must first set a product name on the consent screen.". Go through the questions, like, what type your application is, and then you're done. I'm selecting Web App for this tutorial. In the next, when you have created your app, in the redirect url write the url you wish to use when authenticating. Do NOT use ```localhost```. If you are running on your own, use http://127.0.0.1:port/whatever.

This will get you a ```client ID``` and a ```client secret```. I'm going to save these into a file which will sit next to my web app. It could be stored more securely, for example, in a database or a mounted secure, encrypted drive, and so and so forth, but that's not the point of this tutorial right now.

Now that's done, your application can now be identified, so login can happen using one's Google creds.


The Application
===============

Library
-------

Google has a nice little library to use with OAuth 2.0 which I shall be using as well. The library is available here => [Google OAth 2.0](https://github.com/golang/oauth2). It's a bit cryptic at first to setup, but not to worry. After a little bit of fiddling you'll understand fast what it does, and how you can use it.

Setup - Creds
-------------

So, first, let's create a little setup which configures our credentials from the file. This is pretty straightforward.

~~~Go
// Credentials which stores google ids.
type Credentials struct {
    Cid string `json:"cid"`
    Csecret string `json:"csecret"`
}

func init() {
    var c Credentials
    file, err := ioutil.ReadFile("./creds.json")
    if err != nil {
        fmt.Printf("File error: %v\n", err)
        os.Exit(1)
    }
    json.Unmarshal(file, &c)
}
~~~

Once we have the creds loaded, we can now go on to construct our OAuth client.

Setup - OAuth client
--------------------

First, construct the OAuth config.

~~~Go
conf := &oauth2.Config{
  ClientID:     c.Cid,
  ClientSecret: c.Csecret,
  RedirectURL:  "http://localhost:9090/auth", // If the loging is successful, this will be the redirected URL location to with a query param called 'code'
  Scopes: []string{
    "https://www.googleapis.com/auth/userinfo.email", // You have to select your own scope from here -> https://developers.google.com/identity/protocols/googlescopes#google_sign-in
  },
  Endpoint: google.Endpoint,
}
~~~

This will give you a conf struct which you can then use to Authenticate your user. Once we have this, all we need to do is call ```AuthCodeURL``` on this config. This will give us a URL we need to call which redirects to a Google Sign-In form. Once the user fills that out, it will redirect to the given URL with a callback and provide a TOKEN in form a query parameter called ```code```. This will look something like this ```http://127.0.0.1:9090/auth?code=4FLKFskdjflf....```. To get the URL let's extract this into a small function:

~~~Go
func getLoginURL() string {
    return conf.AuthCodeURL("")
}
~~~

We can put this URL as a link to a Button forexample.

~~~Go
func loginHandler(c *gin.Context) {
    c.Writer.Write([]byte("<html><title>Golang Google</title> <body> <a href='" + getLoginURL() + "'><button>Login with Google!</button> </a> </body></html>"))
}
~~~

Once the user clicks this, (s)he is redirected to Google Sign-In Form which, when filled out, will yield the above URL with a TOKEN in the code section.

Registration
============

So what now? How do we actually get to the registration / login part of this? How does this all fit together? With Google, after you got the token, you can construct an authenticated Google HTTP Client.

Getting the Client
------------------

To obtain the client, you need to do this:

~~~Go
  // Handle the exchange code to initiate a transport.
tok, err := conf.Exchange(oauth2.NoContext, c.Query("code"))
if err != nil {
	c.AbortWithError(http.StatusBadRequest, err)
}

client := conf.Client(oauth2.NoContext, tok)
~~~

That client will now be a Google Authenticated HTTP client. To get something that you can actually use from this do the following...

Obtaining information from the user
-----------------------------------

It's their API url that you need to call with the authenticated client. The code for that:

~~~Go
resp, err := client.Get("https://www.googleapis.com/oauth2/v3/userinfo")
  if err != nil {
  c.AbortWithError(http.StatusBadRequest, err)
}
defer resp.Body.Close()
data, _ := ioutil.ReadAll(resp.Body)
log.Println("Resp body: ", string(data))
~~~

And this will yield a body like this:

~~~json
{
 "sub": "1111111111111111111111",
 "name": "Your Name",
 "given_name": "Your",
 "family_name": "Name",
 "profile": "https://plus.google.com/1111111111111111111111",
 "picture": "https://lh3.googleusercontent.com/asdfadsf/AAAAAAAAAAI/Aasdfads/Xasdfasdfs/photo.jpg",
 "email": "your@gmail.com",
 "email_verified": true,
 "gender": "male"
}
~~~

Tadaam. Parse this, and you've got an email which you can store. Check this against a db record if you already have that email and you have your registration / login.

Putting it all together
=======================

How does this all look together? Something like this. Though, I've built no front-end.

~~~Go
package main

import (
    "fmt"
    "encoding/json"
    "io/ioutil"
    "log"
    "os"
    "net/http"

    "github.com/gin-gonic/gin"
    "golang.org/x/oauth2"
    "golang.org/x/oauth2/google"
)

// Credentials which stores google ids.
type Credentials struct {
    Cid     string `json:"cid"`
    Csecret string `json:"csecret"`
}

// User is a retrieved and authentiacted user.
type User struct {
    Sub string `json:"sub"`
    Name string `json:"name"`
    GivenName string `json:"given_name"`
    FamilyName string `json:"family_name"`
    Profile string `json:"profile"`
    Picture string `json:"picture"`
    Email string `json:"email"`
    EmailVerified string `json:"email_verified"`
    Gender string `json:"gender"`
}

var cred Credentials
var conf *oauth2.Config

func indexHandler(c *gin.Context) {
    c.HTML(http.StatusOK, "index.tmpl", gin.H{})
}

func battleHandler(c *gin.Context) {
    c.HTML(http.StatusOK, "battle.tmpl", gin.H{
        "user": "Anyad",
    })
}

func init() {
    file, err := ioutil.ReadFile("./creds.json")
    if err != nil {
        log.Printf("File error: %v\n", err)
        os.Exit(1)
    }
    json.Unmarshal(file, &cred)

    conf = &oauth2.Config{
        ClientID:     cred.Cid,
        ClientSecret: cred.Csecret,
        RedirectURL:  "http://127.0.0.1:9090/auth",
        Scopes: []string{
        "https://www.googleapis.com/auth/userinfo.email", // You have to select your own scope from here -> https://developers.google.com/identity/protocols/googlescopes#google_sign-in
        },
        Endpoint: google.Endpoint,
    }
}

func getLoginURL() string {
    return conf.AuthCodeURL("")
}

func authHandler(c *gin.Context) {
    // Handle the exchange code to initiate a transport.
	tok, err := conf.Exchange(oauth2.NoContext, c.Query("code"))
	if err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
	}

	client := conf.Client(oauth2.NoContext, tok)
	email, err := client.Get("https://www.googleapis.com/oauth2/v3/userinfo")
    if err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
	}
    defer email.Body.Close()
    data, _ := ioutil.ReadAll(email.Body)
    log.Println("Email body: ", string(data))
    c.Status(http.StatusOK)
}

func loginHandler(c *gin.Context) {
    c.Writer.Write([]byte("<html><title>Golang Google</title> <body> <a href='" + getLoginURL() + "'><button>Login with Google!</button> </a> </body></html>"))
}

func main() {
    router := gin.Default()
    router.Static("/css", "./static/css")
    router.Static("/img", "./static/img")
    router.LoadHTMLGlob("templates/*")

    router.GET("/", indexHandler)
    router.GET("/login", loginHandler)
    router.GET("/auth", authHandler)

    router.Run("127.0.0.1:9090")
}
~~~

This is it folks. Notice that there are some more stuff in there. Disregard them, or delete them. Like the index handler and the templates. They are just something that I used.

After you have the email, you should be able to go on and store it and retrieve it later if you want. With Gin, you can even do authenticated end-points.


~~~Go
authorized := r.Group("/")
// per group middleware! in this case we use the custom created
// AuthRequired() middleware just in the "authorized" group.
authorized.Use(AuthRequired)
{
    authorized.POST("/login", loginEndpoint)
    authorized.POST("/submit", submitEndpoint)
    authorized.POST("/read", readEndpoint)

    // nested group
    testing := authorized.Group("testing")
    testing.GET("/analytics", analyticsEndpoint)
}
~~~

Once you have your Google Auth, you can access these URLS, or do a c.AbortWithError which will stop the chain and redirect the user to a Login page.

I hope this helped. Any comments, please feel free to drop a comment.

Google API Documentation
========================

The documentation to this whole process and MUCH more information can be found here => [Google API Docs](https://developers.google.com/identity/protocols/OAuth2).

Thanks for reading,
Gergely.
