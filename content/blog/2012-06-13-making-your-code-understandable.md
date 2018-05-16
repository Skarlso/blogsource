+++
author = "hannibal"
categories = ["knowledge", "programming"]
date = "2012-06-13"
type = "post"
tags = ["readability"]
title = "Making your code understandable"
url = "/2012/06/13/making-your-code-understandable/"

+++

Hi!

I&#8217;ve seen this many times over and over again. Many people have wrote books about it already. Like Uncle Bob&#8217;s Clean Code. Like Pragmatic Programmer by Andrew Hunt and David Thomas. What makes your code understandable to others. 

Is it **Comments**?

No. It&#8217;s not comments. If your code could be read properly you wouldn&#8217;t need comments to explain what it does. Like Uncle Bob said. A good code doesn&#8217;t contain surprises. It does exactly what you would think it should do on the next line. It doesn&#8217;t have curves and misinformation. It doesn&#8217;t have plots and turns of events like a good crime book. No. Good code is a like a boring soap opera with predictable plot and boring plain characters who don&#8217;t change there behavior based on circumstances. 

Good code is easy to read. It flows like the river, falls like a waterfall, cooks like bacon and crosses the road like a professional chicken. If I read line A the next line should be B. If it is a Z or a :@L$&#8230; I wont be happy. 

So then what makes it understandable?

On simple word: **Readability**.

What makes it readable?

Small chunks of functions that have descriptive names as few parameters as possible and do only ONE thing at a time. Of course this is not all there is&#8230; However it&#8217;s the best thing to begin with. A function called &#8220;doStuff&#8221; that has a complexity of 300 has three fors, two switches and a dozen ifs isn&#8217;t really helping. Now if you look at doStuff and try to give a name based on the job of the function and come up with &#8220;propageXWithFiveUnlessYEqualsTheSumOfZPlusW&#8221; you will know it does more then one thing. 

If you see a really complex function in your production code or hobby code ask yourself: &#8220;Should this really be like 300 lines long and with a complexity of 200??&#8221; And as you speak this out loud you will know the answer already. Break it up. Have like a dozen smaller functions that will be better I promise you. Take out parts. Write unit tests to it that help with re-factoring. Break it down into as small chunks as possible. It will be worth it. It will increase understand-ability, readability and maintainability. 

Hope that helped. 

Thank you for reading and as always,
  
Have a nice Day,
  
Gergely.