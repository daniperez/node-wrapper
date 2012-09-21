 * * *
node-wrapper
============

The goal of node-wrapper is to bootstrap development environments based
on [node.js](http://nodejs.org)' build tools such as [grunt](http://gruntjs.com/)
or [brunch](http://brunch.io).

 * * *

The Importance of Bootstrapping 
-------------------------------

Start hacking on any project shouldn't involve following long installing instructions.
Any instruction, any single setup step should be automatized in a script. The script
becomes your instructions.

For a better explanation about how good bootstrapping is, check [Zach's Unsucking Your Team's Development Environment presentation](http://zachholman.com/talk/unsucking-your-teams-development-environment). Also inspired by
[Gradle Wrapper](http://gradle.org/docs/current/userguide/gradle_wrapper.html).

Getting started
---------------

The easiest way of getting started is to copy ```node-wrapper``` and
```node-wrapper.bat``` to your project root folder where your build or configuration
scripts are. But rename them to match your tool of choice.

If you wanted to use [brunch](http://brunch.io) for example, copy
```node-wrapper``` and ```node-wrapper.bat``` to your project and rename
them to ```brunch``` and ```brunch.bat``` respectively. It's important
to copy both scripts to have both Unix and Windows developers happy.
Once the files are copied, you can execute them as a replacement of
the original [brunch](http://brunch.io) tool: it will check if the
tool is available, if not, it will download it and execute it along
with the parameters passed.

Future
------

*   Allow generic script names like ```autogen.sh``` or ```bootstrap.sh```    
