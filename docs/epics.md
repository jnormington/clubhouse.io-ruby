# Epics

This assumes that you have setup the default client, or will inject your own client.

## Creating

```ruby
epic = Clubhouse::Epic.new(
  name: "Epic One",
  description: 'Epic description',
  state: 'in progress'
)

epic.save
```

Once saved the epic object will be reloaded with the response from clubhouse so now your new
object will have the created_at and updated_at time that is returned from the API.

### Required Fields
* name


## Updating

```ruby
epic = Clubhouse::Epic.new(name: "Epic One").save

epic.state = 'in progress'
epic.save # Save works for both creating and updating

=> <#Clubhouse::Epic... >

```

## Finding by id

```ruby
epic = Clubhouse::Epic.find(3)

=> #<Clubhouse::Epic:0x007ffcd58002d0 @state='to do', @id=3 ... >
```

## Deleting by id

When an empty hash is returned this means it was successfull otherwise it will raise an exception

```ruby
Clubhouse::Epic.delete(3)

=> {}
```

## Listing

Returns a list of all epics

```ruby
Clubhouse::Epic.all

=> [#<Clubhouse::Epic:0x007fb1422da640 @archived=false, @created_at="2016-08-31T22:53:47Z",
@deadline=nil, @description="", @external_id=nil, @follower_ids=[], @name="Epic One", @owner_ids=[],
@state="to do", @updated_at="2016-09-24T16:31:50Z", @id=11, @comments=[], @position=0>]
```
