# Comments

This assumes that you have setup the default client, or will inject your own client.

It is recommended to create comments from a story object as described [here](stories.md)

## Creating

```ruby
comment = Clubhouse::Comment.new(
  story_id: 34,
  text: 'My comment'
)

comment.save
```

Once saved the comment object will be reloaded with the response from clubhouse so now your new
object will have the created_at and updated_at time that is returned from the API.

### Required Fields
* story_id
* text


## Updating

```ruby
comment = Clubhouse::Comment.find(34, 8)

comment.text = "Updated comment"
comment.save # Save works for both creating and updating

=> <#Clubhouse::Comment... >

```

## Finding by id

Finding a comment is different to all other resources the find method takes two arguments

* story_id
* comment_id

```ruby
comment = Clubhouse::Comment.find(34, 8)

=> #<Clubhouse::Comment:0x007ffcd58002d0 @text="Updated comment", @id=8 ... >
```

## Deleting by id

Deleting a comment is different to all other resources the delete method takes two arguments

* story_id
* comment_id

When an empty hash is returned this means it was successfull otherwise it will raise an exception

```ruby
Clubhouse::Comment.delete(34, 8)

=> {}
```
