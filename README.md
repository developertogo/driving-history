# Track Driving History with Ruby

# Objective
The objective of this project is to showcase my design and implementation of production quality code as a member of your development team.

# Design Approach
My goal is to build and structure the code closely resembling how it's done at Root. I searched, watched Meetup videos, and read Root Engineering Blogs. This blog in particular caught my attention: [Separating Data and Code in Rails Architecture](https://medium.com/root-engineering/separating-data-and-code-in-rails-architecture-3a031e17706b). I can relate with it 100% because I'm living it. At my current job, we have many Fat Models and God Classes which has become very difficult to maintain, modify, and manage in a daily basis. 

Given my experience, and what I've learned from the blog, I architected the software with separation of concerns in mind, resulting in a clear tier architecture, and a linear data flow. The code base is structured as follows:

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
There is _100%_ test coverage, see `coverage/index.html` for more details.

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
