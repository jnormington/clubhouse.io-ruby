# Tasks

This assumes that you have setup the default client, or will inject your own client.

It is recommended to create tasks from a story object as described [here](stories.md)

## Creating

```ruby
task = Clubhouse::Task.new(
  story_id: 34,
  description: 'My task',
  complete: false
)

task.save
```

Once saved the task object will be reloaded with the response from clubhouse so now your new
object will have the created_at and updated_at time that is returned from the API.

### Required Fields
* story_id
* description


## Updating

```ruby
task = Clubhouse::Task.find(34, 9)

task.description = "My task"
task.complete = true
task.save # Save works for both creating and updating

=> <#Clubhouse::Task... >

```

## Finding by id

Finding a task is different to all other resources the find method takes two arguments

* story_id
* task_id

```ruby
task = Clubhouse::Task.find(34, 8)

=> #<Clubhouse::Task:0x007ffcd58002d0 @description="Updated task", @id=9, @complete=true ... >
```

## Deleting by id

Deleting a task is different to all other resources the delete method takes two arguments

* story_id
* task_id

When an empty hash is returned this means it was successfull otherwise it will raise an exception

```ruby
Clubhouse::Task.delete(34, 8)

=> {}
```
