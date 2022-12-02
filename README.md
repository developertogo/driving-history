# Track Driving History with Ruby

# Objective
The objective of this project is to showcase my design and implementation of production quality code as a member of your development team.

# Problem Statement

Let's write some code to track driving history for people.

The code will process an input file. You can either choose to accept the input via stdin (e.g. if you're using Ruby cat input.txt | ruby yourcode.rb), or as a file name given on the command line (e.g. ruby yourcode.rb input.txt). You can use any programming language that you want. Please choose a language that allows you to best demonstrate your programming ability.

Each line in the input file will start with a command. There are two possible commands.

The first command is Driver, which will register a new Driver in the app. Example:
```
    Driver Dan
```
The second command is Trip, which will record a trip attributed to a driver. The line will be space delimited with the following fields: the command (Trip), driver name, start time, stop time, miles driven. Times will be given in the format of hours:minutes. We'll use a 24-hour clock and will assume that drivers never drive past midnight (the start time will always be before the end time). Example:
```
Trip Dan 07:15 07:45 17.3
```
Discard any trips that average a speed of less than 5 mph or greater than 100 mph.Generate a report containing each driver with total miles driven and average speed. Sort the output by most miles driven to least. Round miles and miles per hour to the nearest integer.Example input:Driver DanDriver LaurenDriver KumiTrip Dan 07:15 07:45 17.3Trip Dan 06:12 06:32 21.8Trip Lauren 12:01 13:16 42.0Expected output:Lauren: 42 miles @ 34 mphDan: 39 miles @ 47 mphKumi: 0 milesExpectations and Evaluation CriteriaAs experienced software engineers know, there's a wide variety of solutions to any problem. Interview coding problems can be especially unclear about expectations as the tasks can range from a quick fizz buzz screening problem to fully fledged applications. Although we've given a relatively simple problem to solve, we're looking for you to implement enough code to demonstrate expertise with domain modeling and testing.We're interested in the thought process behind your choices, so please take a some time to capture that in your README. For example, you can represent your data using primitives, structs, or objects. We don't consider any one of those options better than the others. However, we expect you to make an intentional choice, implement it consistently, and communicate why you chose that approach.In general, we're looking for a little more structure than what the problem actually necessitates. Although we understand the principle of YAGNI and the desire to keep code simple, we didn't want to add so many requirements to this exercise that it'd take a massive amount of time. Don't go overboard with this — we don't want to see a complex overabundance of abstraction. We also don't want to see all of the code in a single function, even though this problem is simple enough to reasonably implement it that way.We'll be evaluating solutions on:object modeling / software designtesting approachuse of language idioms relative to expertise with that languagethought process captured in the README

# Design Approach
My primary goal is to design the backend to avoid the classic phenomemum of Fat Models and [God Classes](http://wiki.c2.com/?GodClass). 

Architected the software with separation of concerns in mind, resulting in a clear tier architecture, and a linear data flow. The code base is structured as follows:

* _**models**_: contain data only. No business logic
* _models/factory/**model_factory.rb**_: is the singleton model creator. Keeps data persistency
* _**services**_: provide the business logic as procedural static methods
* _**reports**_: provide the report generation as procedural static methods

# Implementation
Below is a few stats of the code base.
#### Application LOC
```
$ find app -iname '*.rb' | xargs wc -l | grep total$
    206 total
```
#### Testing LOC
```
$ find spec -iname '*_spec.rb' | xargs wc -l | grep total$
    530 total
```
#### Test Coverage
There is _100%_ test coverage, see [coverage/index.html](https://github.com/developertogo/driving-history/blob/master/coverage/index.html~) for more details:

![Test Coverage](https://github.com/developertogo/driving-history/blob/master/docs/test-coverage.png)

# Run Program
Run program as follows:
```
ruby track_driving_history.rb input.txt
```
**Note**: This code was tested with Ruby 2.4.5

# Unit Tests
Run unit tests as follows:
```
$ rspec
```
