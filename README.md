# redis-proto.cr [![Build Status](https://travis-ci.org/maiha/redis-proto.cr.svg?branch=master)](https://travis-ci.org/maiha/redis-proto.cr)

A handy Redis storage with Protobuf objects for [Crystal](http://crystal-lang.org/).

```crystal
storage = RedisProto(User).new("redis://", prefix: "users/", primary: "id")
storage.set(user)
storage.get("maiha")
```

- tested on crystal-0.23.1

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  redis-proto:
    github: maiha/redis-proto.cr
    version: 0.1.1
```

## Usage

Assumed that you have `Foo` class of Protobuf::Message.

```crystal
require "redis-proto"

storage = RedisProto(Foo).new("redis://", prefix: "foo/", primary: "id")

foo = Foo.new(id: "a", name: "xyz")
storage.set(foo)
```

```shell
% redis-cli get foo/a
"\n\u{1}a\u{12}\u{3}xyz"
```

```crystal
bar = storage.get("a")
bar.id    # => "a"
bar.name  # => "xyz"

storage.get?("XXX")  # => nil
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/maiha/redis-proto.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
