# mvc_pattern

![Flutter + MVC](https://i.imgur.com/MdZJpMi.png)
###### The "Kiss" of Flutter Frameworks

In keeping with the ["KISS Principle"](https://en.wikipedia.org/wiki/KISS_principle), this was an attempt
to offer the MVC design pattern to Flutter in a simple 
and hopefully intrinsic fashion. I've made the effort to incorporate much of the Flutter framework.

Like many design patterns, **MVC** aims to separate 'the areas of work', to separate 'the areas of responsibiltiy.' With this design pattern, it decouples three major components to allow for efficient code reuse and parallel development, each responsible for separate tasks:

* Model - the Controller’s source for data. Likely contains the business logic.
* View - concerned with how data is displayed. Primarily concern with the UI.
* Controller - controls what data is displayed. Answers to both system or user events.

The version of MVC conveyed in this implementation is more of a [PAC (Presentation-abstraction-control)](https://softwareengineering.stackexchange.com/questions/207620/what-are-the-downfalls-of-mvc#answer-207672) pattern instead of the classic MVC. In the PAC pattern, the Controller can contain a business layer. Ideally, this design pattern would have the code in the 'View' not directly affect or interfere with the code involved in the 'Model' or vice versa. While the 'Contoller', in this arrangement, controls the 'state' of the application during its lifecycle. The View can 'talk to' the Controller; The Controller can 'talk to' the Model.

![MVC Diagram](https://i.imgur.com/r4C1y28.png)

This implementation does allow you to implement a more classic pattern, and allowing the Model to talk to the View.  

Placed in your **main.dart** file, only four simple Classes are involved with the intent here to make the implementation of **MVC** in Flutter as intuitive as possible.
Further notice how Dependency Injection is introduced in its purest form:
Each **MVC** component is appropriately passed to another as a parameter.
![4 Classes](https://i.imgur.com/BqxMSeP.png)


Simply inherit from the three "KISS" MVC Classes: 
AppModel, AppView and AppController

Below, for example, are subclasses of those three MVC Classes.
Now you fill them up with what will make up your Flutter applcation
(with the appropriate code in the appropriate Class), and you're done!

Model Class
![Model](https://i.imgur.com/mUIo8sq.png)
View Class
![View](https://i.imgur.com/3N73L5D.png)
Controller Class
![Controller](https://i.imgur.com/FVX3YHx.png)


**Think of it this way...**
> The 'View' is the **build()** function. It deals with the user-interface in the app.

> The 'Controller' is everything else. It deals with the business logic in the app.
                                  
## 'View' is the `build()` function
You override the **build()** function found in the `State<T extends StatefulWidget>`('the View').
Of course, this being a MVC design pattern, most of the 'data' the View needs to display or what have you comes from the Controller `(e.g. _con.telephoneNumber()).`
The Controller is passed as a parameter to your 'View'. You are to let the Controller
worry about what data to display, and the View worry about how to display it.
Finally, like the traditional build function, you do the **setState()** function if you need it. Although most calls, by MVC design, will now instead come from the passed
Controller reference (e.g _con.invoiceTotal()).
 
## 'Controller' is `StatefulWidget` + `State<T extends StatefulWidget>`
And like the State object, you have access to the usual properties: **widget**, **context** and **mounted**. Further, the Controller (and it's data info.) will persist between **build()** function calls like the State object.

## Dart Programming Language
Further, with Flutter written in the Dart programming language, you can have your 'View'
and 'Controller' Class in a separate files (e.g. View.dart). And, unlike .java files, a file
name need not correspond to a particular Class name inside. With your 'View' file, for example,
you can have all the code responsible for the 'look and feel' of your app all in one place.

In Dart, you can define code outside of classes. Variables, functions, getters, and 
setters can all live outside of classes. So not only the Class that overrides the build() function
, but as many top-level functions, top-level variables and as many other Classes you like
can make of the 'View', the 'Controller' or the 'Model'
---all in one file. Or in multiple files, and you simply import them.

## Try it out now
In Flutter, its possible to 'try before you fork' this repo by inserting this git url
into your metadata file, **pubspec.yaml**: `git://github.com/AndriousSolutions/mvc.git`
![mvc git url](https://i.imgur.com/gIc1ejh.png)

![Exclaimation Point](https://i.imgur.com/KfdDFVK.png)
This repo won't last forever(Nothing ever does). Download it. Make it better. Then Share.

## Read the Article...
[An MVC approach to Flutter](https://proandroiddev.com/mvc-in-flutter-ebfba2a78842) - for 
more insight of how this was intended to work.
          
## Getting Started with Flutter

[Online Documentation](https://flutter.io/)
