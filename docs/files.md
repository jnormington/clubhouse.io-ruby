# Files

This assumes that you have setup the default client, or will inject your own client.

## Creating

You are unable to create files but can create linked files [here](linked_files.md)

## Updating

```ruby
file = Clubhouse::File.find(12)

file.name = 'New file name'
file.description = 'File description'
file.save

=> <#Clubhouse::File... >

```

## Finding by id

```ruby
file = Clubhouse::File.find(12)

=> #<Clubhouse::File:0x007ffcd58002d0 @name='Screenshot 1', @id=12 ... >
```

## Deleting by id

When an empty hash is returned this means it was successfull otherwise it will raise an exception

```ruby
Clubhouse::File.delete(12)

=> {}
```

## Listing

Returns a list of all files uploaded via cllubhouse web

```ruby
Clubhouse::File.all

=> [#<Clubhouse::File:0x007fb1422b0a98 @created_at="2016-09-24T16:38:04Z", @description=nil, @external_id=nil, @name="Screenshot 1"...>]
```
