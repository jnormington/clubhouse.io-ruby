# Stories

This assumes that you have setup the default client, or will inject your own client check out the README if you haven't already.

## Creating

```ruby
story = Clubhouse::Story.new(
  comments:[ {text: 'A comment to start the story'} ],
  deadline: '2016-12-31T12:30:00Z',
  estimate: 8,
  labels: [ {name: 'High'}, {name: :bug } ],
  name: "Can't login and get 503",
  project_id: 17,
  story_type: :bug,
  tasks: [ {description: 'Monitor server load' } ],
  workflow_state_id: 2
)

story.save
```

Once saved the story object will be reloaded with the response from clubhouse so now your new object will have the created_at and updated_at time that is returned from the API.

### Required Fields
* name
* project_id


## Updating

```ruby
story = Clubhouse::Story.new(name: "Can't login and get 503", project_id: 17).save

story.story_type = 'bug'
story.save # Save works for both creating and updating and only sends the attributes which are permitted

=> <#Clubhouse::Story... >

```

## Finding by id

```ruby
story = Clubhouse::Story.find(696)

=> #<Clubhouse::Story:0x007ffcd58002d0 @archived=false, @id=696 ... >
```

## Deleting by id

When an empty hash is returned this means it was successfull otherwise it will raise an exception

```ruby
Clubhouse::Story.delete(696)

=> {}
```

## Adding comments and tasks quickly

Once you have saved your story or you find a story and want to add a comment or task quickly. You can do so with the following method calls

```ruby

story = Clubhouse::Story.find(696)

story.add_comment('My comment here')
=> [#<Clubhouse::Comment:0x007ffcd41518b8 @text="My comment here", @story_id=696, @author_id="57c75ddd-ad27-4531-8c7d-368d8702cc0d", @created_at... >, <#Clubhouse::Comment>]

story.add_task('Add acceptance spec')
=> [#<Clubhouse::Task:0x007ffcd434efd0 @complete=false, @created_at="2016-09-25T16:44:35Z", @description="Write acceptance spec"...>, <#Clubhouse::Task>]

```

When you add a comment or a task it will return an array of all the comments or tasks that exist
on that story, you can access all the comments and task and modify them by calling comments or tasks on the story object.

## Searching

Searching for stories is open and not restricted. It takes a hash of key, value.
You can check which search attributes are valid [here](https://clubhouse.io/api/v1/#search-stories)

```ruby
Clubhouse::Story.search(project_id: 17, estimate: 5, epic_id: 1)

=> [#<Clubhouse::Story:0x007ffcd58002d0 @archived=false, @id=696 ... >]
```

## Failure
All the request calls can fail and if they do you will be presented with an exception.
The exception will be explanatory of the issue with the full body content response of the problem from Clubhouse API

```
Clubhouse::BadRequestError: {"message":"The request included invalid or missing parameters.","errors":{"name":"missing-required-key","project_id":"missing-required-key"}
```
