# Pimple for Ruby

This is the Ruby implementation of Pimple, originally a leightweight Dependancy Injection library written in PHP and created by Fabien Potencier.

Refer to [the original documentation](http://pimple.sensiolabs.org/) for more details about Pimple, you could found better explanations on the topic.

## Installation

Install with RubyGems :

```shell
sudo gem install pimple
```

Then, create the container : 

```ruby
require 'pimple'
container = Pimple.new
``` 

## Defining parameter

```ruby
container[:foo] = 'bar'
container[:foo] # => bar
```

## Defining services

Pimple is built to provide services on demand. Just wrap a return instance to pimple in a lambda and get your service later when you need its functionnalities.

See that example to inject a redis client with some parameters:

```ruby
# Defining redis config in container as parameter before ...
container[:redis_config] = {:host => 'localhost', :port => 6379}

# Defining the redis client into Pimple
container[:redis] = lambda { Redis.new(container[:redis_config]) }

# And get an instance
container[:redis] # => #<Redis client v2.1.1 connected to redis://localhost:6379/0 (Redis v2.2.2)>
```

**Important!** : Each time you get a service by its key, Pimple will call your defined lambda and then return a new instance.

## Defining shared services (Singleton like)

Sometimes, you need to work with the same instance each time you access to your service. Use `share` method as shown as below :

```ruby
container[:session_storage] = container.share { Redis.new }
```

## Defining protected parameter (Wrap anonymous function as parameter)

Anonymous functions (lambda) can be passed to the container to provide a method that make something. To ensure the lambda will be not evaluated as a service, you need to use `protect` method. Then, when you get the value from the container, you just have to to access the container value to automatically call the function. 
Let me show you an example with a random function : 

```ruby
# First of all, we inject the random function
container[:random] = container.protect { rand(100) }

# ... and sometime in the future, we want a random number.
# So we call the function from the container by its key
container[:random] # => 12
# ... and get another one later !
container[:random] # => 48
```

## Extend services

Not implemented

# Contribute <3

I'm sure this library can be improved by many ways. If you want to improve some stuff, feel free to send a pull-request with your changes. One condition, ensure to test and document your code ;).

# License

Released under the MIT License. View LICENSE file for details.
Copyright (c) 2012 Florian Mhun.