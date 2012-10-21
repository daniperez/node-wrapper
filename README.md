node-wrapper
============

The goal of node-wrapper is to bootstrap development environments based
on [node.js](http://nodejs.org) build tools such as [grunt](http://gruntjs.com/)
or [brunch](http://brunch.io).

The Importance of Bootstrapping 
-------------------------------

Hacking on a project shouldn't involve following long installing instructions.
Any instruction, any single setup step should be automatized in a script. 
The script becomes your instructions.

While tools such as [grunt](http://gruntjs.com/) or [brunch](http://brunch.io)
allow to automate everything, developers still have to install [node.js](http://nodejs.org)
and the build tool of choice. With ```node-wrapper``` you don't need to install
any of them: it will check if the tool is available, otherwise it will
download it along with [node.js](http://nodejs.org) if necessary.

For a better explanation about how good bootstrapping is, check [Zach's Unsucking Your Team's Development Environment presentation](http://zachholman.com/talk/unsucking-your-teams-development-environment). Also inspired by
[Gradle Wrapper](http://gradle.org/docs/current/userguide/gradle_wrapper.html).

Getting started
---------------

The easiest way of getting started is to copy ```node-wrapper``` and
```node-wrapper.bat``` to your project root folder where your build or
configuration scripts are. Then rename them to match your tool of choice.

For example, if you wanted to use [brunch](http://brunch.io), copy
```node-wrapper``` and ```node-wrapper.bat``` to your project and rename
them to ```brunch``` and ```brunch.bat``` respectively. It's important
to copy both scripts to have both Unix and Windows developers happy.
Once the files are copied, you can execute them as a replacement of
the original [brunch](http://brunch.io) tool: it will check if the
tool is available, if not, it will download it and execute it along
with the parameters passed.

You can also keep the original name of the scripts, ```node-wrapper```,
and pass the tool name as first argument:
```shell
> ./node-wrapper brunch build
```

Windows caveat
--------------

The Windows version, ```node-wrapper.bat```, needs to download and unzip
```npm```, therefore I had to use ```7za.exe``` since it doesn't
seem to exist an uniform way of unzipping files in Windows. Copy ```7za.exe``` along with
```node-wrapper.bat``` if you use ```node-wrapper``` in Windows (BTW any Windows hacker
knowing how to fix this unwanted dependency?).
