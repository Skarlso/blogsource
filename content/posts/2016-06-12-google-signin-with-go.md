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

Today, I would like to write up a step - by - step guide with a sample web app on how to do Google Sign-In and authorization.

<!--more-->

Let's get started.

Setup
=====

Google OAuth token
------------------

First what you need is, to register your application with Google, so you'll get a Token that you can use to authorize later calls to Google services.

You can do that here: [Google Developer Console](https://console.developers.google.com/iam-admin/projects). You'll have to create a new project. Once it's done, click on ```Credentials``` and create an OAuth token. You should see something like this: "To create an OAuth client ID, you must first set a product name on the consent screen.". Go through the questions, like, what type your application is, and once you arrive at stage where it's asking for your application's name -- there is a section asking for redirect URLs; there, write the url you wish to use when authorising your user. If you don't know this yet, don't fret, you can come back and change it later. Do NOT use ```localhost```. If you are running on your own, use http://127.0.0.1:port/whatever.

This will get you a ```client ID``` and a ```client secret```. I'm going to save these into a file which will sit next to my web app. It could be stored more securely, for example, in a database or a mounted secure, encrypted drive, and so and so forth.

Your application can now be identified through Google services.


The Application
===============

Library
-------

Google has a nice library to use with OAuth 2.0. The library is available here: [Google OAth 2.0](https://github.com/golang/oauth2). It's a bit cryptic at first, but not to worry. After a bit of fiddling you'll understand fast what it does.

Setup - Credentials
-------------------

Let's create a setup which configures you're credentials from the file you saved earlier. This is pretty straightforward.

~~~go
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

Once you have the creds loaded, you can now go on to construct the OAuth client.

Setup - OAuth client
--------------------

Construct the OAuth config like this:

~~~go
conf := &oauth2.Config{
  ClientID:     c.Cid,
  ClientSecret: c.Csecret,
  RedirectURL:  "http://localhost:9090/auth",
  Scopes: []string{
    "https://www.googleapis.com/auth/userinfo.email", // You have to select your own scope from here -> https://developers.google.com/identity/protocols/googlescopes#google_sign-in
  },
  Endpoint: google.Endpoint,
}
~~~

It will give you a conf struct which you can then use to Authorize your user in the google domain. Next, all you need to do is call ```AuthCodeURL``` on this config. It will give you a URL you need to call which redirects to a Google Sign-In form. Once the user fills that out and clicks 'Allow', you'll get back a TOKEN in the ```code``` query parameter and a ```state``` which helps protect against CSRF attacks. Always check if the provided state is the same which you provided with AuthCodeURL. This will look something like this ```http://127.0.0.1:9090/auth?code=4FLKFskdjflf3343d4f&state=state```. To get the URL let's extract this into a small function:

~~~go
func getLoginURL() string {
    // State can be some kind of random generated hash string.
    // See relevant RFC: http://tools.ietf.org/html/rfc6749#section-10.12
    return conf.AuthCodeURL("", "myapplicationsnonguessablestatecode")
}
~~~

You can put the return URL as a link to a Button. For example:

~~~go
func loginHandler(c *gin.Context) {
    c.Writer.Write([]byte("<html><title>Golang Google</title> <body> <a href='" + getLoginURL() + "'><button>Login with Google!</button> </a> </body></html>"))
}
~~~

The link provided here, will be the Sign-In form redirection URL.

Registration
============

With Google, after you got the token, you can construct an authorised Google HTTP Client which let's you call Google related services and retrieve information about the user.

Getting the Client
------------------

To obtain the client, you need to do this:

~~~go
  // Handle the exchange code to initiate a transport.
tok, err := conf.Exchange(oauth2.NoContext, c.Query("code"))
if err != nil {
	c.AbortWithError(http.StatusBadRequest, err)
}

client := conf.Client(oauth2.NoContext, tok)
~~~

To get something that you can actually can use from this -- for example and email address -- do the following...

Obtaining information from the user
-----------------------------------

It's their API url that you need to call with the authorised client. The code for that is:

~~~go
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

Parse this, and you've got an email which you can store somewhere for registration purposes. Note, that this does ```not``` mean yet that your user at this point is authenticated. That will depend on your application's structure of handling said user. Like, creating a token to track the user's state with JWT, and retrieving the user's information from a database. I'm going to post a second part of that happening.

Putting it all together
=======================

All the code together looks like this (disregard the templates):

~~~go
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
var superawesomestatecode string

func indexHandler(c *gin.Context) {
    c.HTML(http.StatusOK, "index.tmpl", gin.H{})
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

    superawesomestatecode = "InitializeItToSomethingAwesome."
}

func getLoginURL() string {
    return conf.AuthCodeURL(superawesomestatecode)
}

func authHandler(c *gin.Context) {

    // Check here if state is the same as provided
    if c.Query("state") != superawesomestatecode {
      c.AbortWithError(http.StatusBadRequest, fmt.Error("Invalid state."))
    }

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

This is it folks. I'm doing some extra in there, like loading static handling for css and img. You can ignore those.

After you have the email, you should be able to go on and store it and retrieve it later if you want. With Gin, you can even do authorised end-points.

~~~go
authorised := r.Group("/")
// Per group middleware! in this case we use the custom created
// AuthRequired() middleware just in the "authorised" group.
authorised.Use(AuthRequired)
{
    authorised.POST("/login", loginEndpoint)
    authorised.POST("/submit", submitEndpoint)
    authorised.POST("/read", readEndpoint)

    // nested group
    testing := authorised.Group("testing")
    testing.GET("/analytics", analyticsEndpoint)
}
~~~

Once you have your Google Auth, you can access these URLS, or do a c.AbortWithError which will stop the chain and redirect the user back to a Login page.

I hope this helped. Any comments or advice are welcomed.

Google API Documentation
========================

The documentation to this whole process and MUCH more information can be found here: [Google API Docs](https://developers.google.com/identity/protocols/OAuth2).

Thanks for reading,
Gergely.
