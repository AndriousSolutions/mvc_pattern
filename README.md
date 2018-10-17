mvc_pattern
===========

![flutter and mvc](https://user-images.githubusercontent.com/32497443/47087365-c9524f80-d1e9-11e8-85e5-6c8bbabb18cc.png)

###### The "Kiss" of Flutter Frameworks

In keeping with the ["KISS
Principle"](https://en.wikipedia.org/wiki/KISS_principle), this is an attempt to
offer the MVC design pattern to Flutter in an intrinsic fashion incorporating
much of the Flutter framework itself. All in a standalone Flutter Plugin. It is
expected the user of this plugin to be knowledgeable with such framework
architectures.

**Usage**

Let’s demonstrate its usage with the ol’ ‘Counter app’ created every time you
start a new Flutter project. In the example below, to utilize the plugin, three
things are changed in the Counter app. The Class, \_MyHomePageState, is extended
with the Class StateMVC, a ‘Controller’ Class is introduced that extends the
Class, ControllerMVC, and a static instance of that Class is made available to
the **build()** function. Done!

With that, there is now a separation of ‘the Interface’ and ‘the data’ as it’s
intended with the MVC architecture. The **build()** function (the View) is
concerned solely with the ‘look and feel’ of the app’s interface—‘how’ things
are displayed. While, in this case, it is the Controller that’s concerned with
‘what’ is displayed.

What data does the View display? It doesn’t know nor does it care! It ‘talks to’
the Controller instead. Again, it is the Controller that determines ‘what’ data
the View displays. In this case, it’s a title and a counter. When a button is
pressed, again, the View again ‘talks to’ the Controller to address the event
(i.e. It calls one of the Controller’s public functions,
**incrementCounter()**).
![myhomepage](https://user-images.githubusercontent.com/32497443/47087491-2221e800-d1ea-11e8-8304-681c5d1e5858.jpg)

![mvc pattern](https://user-images.githubusercontent.com/32497443/47087587-6614ed00-d1ea-11e8-8fc3-ced0ac6af12a.jpg)

In this arrangement, the Controller is ‘talking back’ to the View by calling the
View’s function, **setState()**, to tell it to rebuild.

Maybe we don’t want that. Maybe we want the View to be solely concern with the
interface and only determine when to rebuild or not. It’s a simple change.

![view talks to contoller only](https://user-images.githubusercontent.com/32497443/47087650-88a70600-d1ea-11e8-8212-b785485a3dee.jpg)

![myhomepage](https://user-images.githubusercontent.com/32497443/47087698-aa07f200-d1ea-11e8-8193-38fc3fca6976.jpg)  
It does separate the ‘roles of responsibility’ a little more, doesn’t it? After
all, it is the View that’s concerned with the interface. It would know best when
to rebuild, no? Regardless, with this plugin, such things are left to the
developer. Also, notice what I did with the app’s title? I created a static
String field in the MyApp class called, title. It’s named ‘MyApp’ after all—It
should know its own title.

**How about a Model?**

Currently, in this example, it’s the Controller that’s containing all the
‘business logic’ for the application. In some MVC implementations, it’s the
Model that contains the business rules for the application. So how would that
look? Well, it could maybe look like this:
![controller](https://user-images.githubusercontent.com/32497443/47087743-ca37b100-d1ea-11e8-9e38-92acea125668.jpg)
I decided to make the Model’s API a little cleaner with the use of a static
members. As you can deduce, the changes were just made in the Controller. The
View doesn’t even know the Model exists. It doesn’t need to. It still ‘talks to’
the Controller, but it is now the Model that has all the ‘brains.’

![pac pattern](https://camo.githubusercontent.com/a5b152ecc2f2b96b8019941a7382f47f4ac4c2b6/68747470733a2f2f692e696d6775722e636f6d2f723443317932382e706e67)

However, what if you want the View to talk to the Model? Maybe because the Model
has zillions of functions, and you don’t want the Controller there merely ‘to
relay’ the Model’s functions and properties over to the View. You could simply
provide the Model to the View. The View then calls the Model’s properties and
functions directly.

![mvc pattern classic](https://user-images.githubusercontent.com/32497443/47087797-ef2c2400-d1ea-11e8-8a90-41bbb6b07bf0.jpg)

![myhomepagestate](https://user-images.githubusercontent.com/32497443/47087832-0b2fc580-d1eb-11e8-8977-0c2bc206e8be.jpg)
Not particularly pretty. I would have just kept the Static members in the Model,
and have the View call them instead (or not do that at all frankly), but I’m
merely demonstrating the possibilities. With this MVC implementation, you have
options, and developers love options.

**How’s It Works?**

When working with is MVC implementation, you generally override two classes: The
Controller (Class ControllerMVC) and the StateView (Class StateMVC). Below is a
typical approach to overriding the Controller.
![con](https://user-images.githubusercontent.com/32497443/47087878-24387680-d1eb-11e8-820e-dd677a18a854.jpg)
The Controller has ‘direct access’ to the View (aka. the StateView, aka. the
Class StateMVC). This is represented by the property, stateView in the Class,
ControllerMVC. In this example, a ‘static’ reference to the View as well as to
the Controller itself is made in the Constructor. This example conveys a good
approach because it then allows, for example, easy access to your Controller
throughout the app. It’s now in a static field called **con**. See how it’s now
easily accessed in another Dart file below:
![addeditscreen](https://user-images.githubusercontent.com/32497443/47087913-3adecd80-d1eb-11e8-9a90-5c625d184503.jpg) 
Now, in any View or any Widget for that matter, you can access the app’s data or
business logic easily and cleanly through it’s Controller (e.g. Easily reference
the Controller in a **build()** function.)

The other Class (StateMVC) has called ‘StateView’ as it is a State object as
well as ‘the View.’
![homescreen](https://user-images.githubusercontent.com/32497443/47087951-58139c00-d1eb-11e8-93ec-95eb29e8cf24.jpg)

Note, the StateView, like the State Class is abstract and must be extended to
implement its **build()** function. So the View, in this MVC implementation, is
simply the State’s object’s **build()** function.
![statemvc](https://user-images.githubusercontent.com/32497443/47088002-78dbf180-d1eb-11e8-9ad4-c719678c381d.jpg)

**The Controller**

Note, the Controller class (ControllerMVC) looks pretty thin at first glance.
That’s to give you all the room you need to code your app! Don’t worry. All the
‘leg work’ is done in the Class, \_StateView.
![controllermvc](https://user-images.githubusercontent.com/32497443/47088047-901adf00-d1eb-11e8-8979-5d31db576ccd.jpg)

**Set the State**

The ‘StateView’, of course, has the *setState()* function. It’s a State Object
after all. However, with this implementation, you also have the *setState()*
function in the Controller! You can call it in both Classes. Nice.
![setstate](https://user-images.githubusercontent.com/32497443/47088112-b3de2500-d1eb-11e8-9bfa-f20df455ab02.jpg)
Both Classes, also have the refresh() function. To ‘refresh’ or ‘rebuild’ the User Interface (The View).
![refresh](https://user-images.githubusercontent.com/32497443/47088148-cc4e3f80-d1eb-11e8-9e02-0ea71528bb8b.jpg)

**Listen! There’re listeners!**

Also note, the ‘Controller’ class has a parent Class called StateEvents. It is
this Class that allows the Controller to response to events generated by the
phone or (indirectly) by the user. As of this release, there are twelve separate
events available to the Class. This StateEvents Class is also available to you.
Extend this Class, and you’ll have an ‘event listener’ to use in your app.
Listeners will fire along side any Controllers assigned to a particular View.
![stateevents](https://user-images.githubusercontent.com/32497443/47088204-eab43b00-d1eb-11e8-9dae-2c782284c7ec.jpg)

Note, a ‘StateEvents Listener’ will not have access to the ‘StateView’ object,
but instead it’s ‘State’ object. If you want more access to ‘the View’, then
your class should extend the class, ControllerMVC.

Below are the three functions used by the Controller (and by the ‘StateView’ for
that matter) to register such Listener objects. Using such functions, the
Controller (Class ControllerMVC) can assign listeners to the View it itself is
assigned to, while the ‘StateView’ (Class StateMVC) can assign listeners
directly.
![addbeforelistener](https://user-images.githubusercontent.com/32497443/47088245-00c1fb80-d1ec-11e8-91a0-44484f5b46d3.jpg)
![addafterlistener](https://user-images.githubusercontent.com/32497443/47088404-6dd59100-d1ec-11e8-8e59-841cedc902e3.jpg)
![addlistener](https://user-images.githubusercontent.com/32497443/47088422-7a59e980-d1ec-11e8-803d-0785d0d30474.jpg)
Of course, you have a means to remove a listener if and when it’s necessary.
![16 removelistener](https://user-images.githubusercontent.com/32497443/47088465-93fb3100-d1ec-11e8-8bb1-0e09e22bbf4d.jpg)

**Before and After**

Note, the function, **addListener()**, does the same thing as the function,
**addAfterListener()**. The ‘before’ and ‘after’ reference means you can assign
listeners that will fire ‘before’ or ‘after’ the Controllers fire. Why? I don’t
know! It’s your app! ;)

**A Function for every Event**

Below, you’ll see the twelve events available to you. Turn to this documentation
for details.
![initstate](https://user-images.githubusercontent.com/32497443/47088498-a5dcd400-d1ec-11e8-9d02-60fdef9501d2.jpg)
![dispose](https://user-images.githubusercontent.com/32497443/47088532-bb51fe00-d1ec-11e8-90e9-070d7a3300b2.jpg) 
![deactivate](https://user-images.githubusercontent.com/32497443/47088595-dcb2ea00-d1ec-11e8-9c15-bcf7e5096562.jpg)
![didupdatewidget](https://user-images.githubusercontent.com/32497443/47088622-eb999c80-d1ec-11e8-8ebf-402fa510bf95.jpg)
![didchangedependencies](https://user-images.githubusercontent.com/32497443/47088641-f8b68b80-d1ec-11e8-9c0e-7f69de145cfd.jpg)
![reassemble](https://user-images.githubusercontent.com/32497443/47088713-1a177780-d1ed-11e8-97f1-85c4bc3362e5.jpg)
![didchangeapplifecyclestate](https://user-images.githubusercontent.com/32497443/47088734-2996c080-d1ed-11e8-9e59-4d57126e99e9.jpg)
![didchangemetrics](https://user-images.githubusercontent.com/32497443/47088761-36b3af80-d1ed-11e8-8c3a-8791addd67d3.jpg)
![didchangetextscalefactor](https://user-images.githubusercontent.com/32497443/47088779-46cb8f00-d1ed-11e8-9465-7dc65eb53267.jpg)
![didchangelocale](https://user-images.githubusercontent.com/32497443/47088802-521eba80-d1ed-11e8-99c1-23852f8c5407.jpg)
![didhavememorypressure](https://user-images.githubusercontent.com/32497443/47088825-5ea31300-d1ed-11e8-9fb0-7a48ab9e8779.jpg)
![didchangeaccessibilityfeatures](https://user-images.githubusercontent.com/32497443/47088842-68c51180-d1ed-11e8-8522-7832c998c48b.jpg)

**How to Start**

Below would be a typical approach to start up an app using this plugin. This is
done by using yet another Class in the MVC Pattern package. It’s called AppMVC.
![app](https://user-images.githubusercontent.com/32497443/47088888-83978600-d1ed-11e8-9e00-6127d72aad13.jpg)

Below is a ‘conceptual representation’ of the AppMVC Class with its logic
removed for brevity. However, what’s left will give you an appreciation of just
what you can do with this Class, and it’s a lot. Again, some of the events are
not listed here, but all twelve of the events mention above could be addressed
at the ‘Application level’ if the developer wishes to. This Class also has the
same functions you would find in a State Object and more.

It even has its own Error Handler…sort of. Currently, its response, if an error
does occur, by default is the usual ‘red screen of death’ response. However, you
are free to ‘override’ its **onError()** function and possibly ‘catch’ the
errors and have your application fail, if possible, in a more graceful
fashion….maybe even email an error report somewhere.

In fact, read my (soon to publish) article, Flutter + MVC at last!, and you’ll
see this plugin places an Error Handler in everything you make: in every
Controller, every Listener, every View and even, in certain circumstances, every
State Object’s build() function! You’ll soon realize that Error Handling is
paramount in this framework!
![appmvc](https://user-images.githubusercontent.com/32497443/47093615-96af5380-d1f7-11e8-8d8e-f36ae1c67a25.jpg)

Two ‘new’ functions exist solely for the ‘App Class’: **initApp()** and
**init()**. A lot of things have to ‘start up’ when starting up an App, and
these two functions provide a place just for that. The function, **initApp()**,
is for ‘quick’ synchronous processes while the **init()** function returns a
Future and so is for asynchronous operations. Usually a **FutureBuilder()**
function is then called upon. One usually has to wait for such ‘asynchronous
stuff’ to complete before continuing, and so, for example, a ‘Loading Screen’ is
displayed while we wait.
![futurebuilder](https://user-images.githubusercontent.com/32497443/47088920-a0cc5480-d1ed-11e8-8e87-b4e8e46042b0.jpg)

Read, (coming soon!)Flutter + MVC at Last! - for more a more extensive explanation for this
framework plugin.

