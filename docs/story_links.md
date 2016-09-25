# StoryLinks

This assumes that you have setup the default client, or will inject your own client.

## Creating

```ruby
story_link = Clubhouse::StoryLink.new(
  subject_id: 3,
  object_id: 2,
  verb: 'blocks'
)

story_link.save
```

Once saved the story link object will be reloaded with the response from clubhouse so now your new
object will have the created_at and updated_at time that is returned from the API.

### Required Fields
* subject_id
* object_id
* verb (blocks, duplicates, relates to)


## Updating

You can't update a story link best thing is to delete and recreate


## Deleting by id

When an empty hash is returned this means it was successfull otherwise it will raise an exception

```ruby
Clubhouse::StoryLink.delete(8)

=> {}
```
