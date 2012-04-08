# Pimple for Ruby

This is the Ruby implementation of Pimple, originally a leightweight Dependancy Injection library written in PHP and created by Fabien Potencier.

## Installation

```ruby
container = Pimple.new
```

## Define parameter

```ruby
container[:foo] = 'value'
container[:foo] # => value
```

## Wrap anonymous function as parameter

```ruby
container.protect(:random) { rand(100) }

# First time
container[:random] # => 12
# Second time
container[:random] # => 48
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

## Shared services (Singleton like)

Sometimes, you need to work with the same instance each time you access to your service. Use `share` method as shown as below :

```ruby
container[:session_storage] = container.share(:session_storage) { Redis.new }
```

## Extend services

Not implemented

# Contribute <3

I'm sure this library can be improved by many ways. If you want to improve some stuff, feel free to send a pull-request with your changes. One condition, ensure to test and document your code ;).

# License

Released under the MIT License. View LICENSE file for details.
Copyright (c) 2012 Florian Mhun.