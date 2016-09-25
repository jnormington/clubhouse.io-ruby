# Projects

This assumes that you have setup the default client, or will inject your own client.

## Creating

```ruby
project = Clubhouse::Project.new(
  name: "Project One",
  description: 'Project description',
  color: '#222'
)

project.save
```

Once saved the project object will be reloaded with the response from clubhouse so now your new
object will have the created_at and updated_at time that is returned from the API.

### Required Fields
* name


## Updating

```ruby
project = Clubhouse::Project.find(8)

project.archived = true
project.save # Save works for both creating and updating

=> <#Clubhouse::Project... >

```

## Finding by id

```ruby
project = Clubhouse::Project.find(8)

=> #<Clubhouse::Project:0x007ffcd58002d0 @archived=true, @id=8 ... >
```

## Deleting by id

When an empty hash is returned this means it was successfull otherwise it will raise an exception

```ruby
Clubhouse::Project.delete(8)

=> {}
```

## Listing

Returns a list of all projects

```ruby
Clubhouse::Project.all

=> [#<Clubhouse::Project:0x007fb142440458 @abbreviation="PT"...>]
```

## Listing all stories for a project

Returns all the stories for the current project

```ruby
project = Clubhouse::Project.find(8)

project.stories

=> [#<Clubhouse::Story:0x007fb144089178 @archived=false, @comments=[{"...>, #<Clubhouse::Story>]
```
