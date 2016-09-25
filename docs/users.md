# Users

This assumes that you have setup the default client, or will inject your own client.

## Creating, Updating, Deleting

You can't create, update or delete users via the API this needs to happen only via Clubhouse web


## Finding by id

```ruby
epic = Clubhouse::User.find(3)

=> #<Clubhouse::User:0x007ffcd58002d0 @disabled=false, @id=3 ... >
```

## Listing

Returns a list of all users

```ruby
Clubhouse::User.all

=> [#<Clubhouse::User:0x007fb142170e58 @name="Tester", @deactivated=false,..>, #<Clubhouse::User...>]
```
