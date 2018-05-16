+++
author = "hannibal"
categories = ["testing"]
date = "2015-01-28"
type = "post"
tags = ["cucumber"]
title = "When cucumber goes wrong"
url = "/2015/01/28/when-cucumber-goes-wrong/"

+++

Hi,

Let&#8217;s face the horrible truth:

**It&#8217;s rare / never happens that a manager / scrum master / product owner actually reads your cucumber test cases.**

<!--more-->

Back in the old days, this was one of the selling points of human readable tests and DSLs. It sounds nice and I&#8217;m sure in a utopia it also works.

BDD is a very nice approach to write tests if used in a correct way. And I can relate that at some point, a manager or the product owner, actually writes up a draft of the tests. But that enthusiasm very rarely stays for the rest of the project.

Especially when you get to the point where your Cucumber test cases start to look something like this:

<pre class="prettyprint"><span class="typ">Scenario</span><span class="pun">:</span> <span class="typ">User</span><span class="pln"> list
  </span><span class="typ">Given</span><span class="pln"> I post to </span><span class="str">"/users.json"</span> <span class="kwd">with</span><span class="pun">:</span><span class="pln">
    </span><span class="str">"""
    {
      "</span><span class="pln">first_name</span><span class="str">": "</span><span class="typ">Steve</span><span class="str">",
      "</span><span class="pln">last_name</span><span class="str">": "</span><span class="typ">Richert</span><span class="str">"
    }
    """</span><span class="pln">
  </span><span class="typ">And</span><span class="pln"> I keep the JSON response at </span><span class="str">"id"</span> <span class="kwd">as</span> <span class="str">"USER_ID"</span><span class="pln">
  </span><span class="typ">When</span><span class="pln"> I </span><span class="kwd">get</span> <span class="str">"/users.json"</span><span class="pln">
  </span><span class="typ">Then</span><span class="pln"> the JSON response should have </span><span class="lit">1</span><span class="pln"> user
  </span><span class="typ">And</span><span class="pln"> the JSON response at </span><span class="str">"0"</span><span class="pln"> should be</span><span class="pun">:</span><span class="pln">
    </span><span class="str">"""
    {
      "</span><span class="pln">id</span><span class="str">": %{USER_ID},
      "</span><span class="pln">first_name</span><span class="str">": "</span><span class="typ">Steve</span><span class="str">",
      "</span><span class="pln">last_name</span><span class="str">": "</span><span class="typ">Richert</span><span class="str">"
    }
    """</span></pre>

If a product owner reads this, his reaction will be like: &#8220;What the hell is this? What&#8217;s users.json? Why is it there? Why should I even care? What&#8217;s a JSON response? Why should it match with the request? And what, if I keep the id at USER_ID? Huh?&#8221;

It&#8217;s easy to get overwhelmed by things like this scenario when you start introducing actors into your tests and payloads to your public API. And suddenly you&#8217;ll end up with cucumber features which no other will be able to understand but the person who wrote it.

I&#8217;m a little bit skeptic that it ever worked as intended. Sure, for a little while. But the dynamic nature of tests will surface soon enough. You can&#8217;t hide it forever.

The above example, if the payload and user would be hidden in a reusable code fragment behind the implementation, would look a bit more readable:

<pre class="prettyprint"><span class="typ">Scenario</span><span class="pun">:</span> <span class="typ">User</span><span class="pln"> list
  </span><span class="typ">Given</span><span class="pln"> I post to user list</span> <span class="kwd">with data
</span><span class="pln">  | firstname | Steve |
  | lastname  | Richert |
</span><span class="pln">  </span><span class="typ">When</span><span class="pln"> I </span><span class="kwd">get</span> a response from the SUT<span class="pln">
  </span><span class="typ">Then</span><span class="pln"> the response should have the same user</span></pre>

See? Easier to understand. I don&#8217;t care about the payload. I don&#8217;t care about the user ID, in fact, I would rather see this test as a unit test somewhere deep down in the bowls of the system. Although I can understand that you want a set of automated UATs.

I&#8217;m sure Cucumber has a couple of success stories behind his back, I just didn&#8217;t happen to come across them as of late. But please, if you have one, share it with me so I can rest easily.

Gergely.