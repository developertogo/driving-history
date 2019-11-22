# Track Driving History with Ruby

# Objective
The objective of this project is to showcase my design and implementation of production quality code as a member of your development team.

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
There is _100%_ test coverage, see [coverage/index.html](https://github.com/developertogo/driving-history/blob/master/coverage/index.html) for more details:

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
