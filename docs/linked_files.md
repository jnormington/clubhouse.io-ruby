# LinkedFiles

This assumes that you have setup the default client, or will inject your own client.

## Creating

```ruby
linked_file = Clubhouse::LinkedFile.new(
  name: "LinkedFile One",
  type: 'url',
  url: 'https://dropbox.com/1/files/image.png'
)

linked_file.save
```

Once saved the linked file object will be reloaded with the response from clubhouse so now your new
object will have the created_at and updated_at time that is returned from the API.

### Required Fields
* name
* type (google, url, dropbox, box, onedrive)
* url


## Updating

```ruby
linked_file = Clubhouse::LinkedFile.find(23)

linked_file.thumbnail_url = 'https://dropbox.com/1/files/image.png?size=thumbnail'
linked_file.save # Save works for both creating and updating

=> <#Clubhouse::LinkedFile... >

```

## Finding by id

```ruby
linked_file = Clubhouse::LinkedFile.find(23)

=> #<Clubhouse::LinkedFile:0x007ffcd58002d0 @url='https://dropbox.com/1/file/image.png', @id=23 ... >
```

## Deleting by id

When an empty hash is returned this means it was successfull otherwise it will raise an exception

```ruby
Clubhouse::LinkedFile.delete(23)

=> {}
```

## Listing

Returns a list of all linked files uploaded by the API

```ruby
Clubhouse::LinkedFile.all

=> [#<Clubhouse::LinkedFile:0x007fb142223508 @content_type="", @description="", @name="attachment0", @size=230, @story_id=nil, @thumbnail_u...>]
```
