# Labels

This assumes that you have setup the default client, or will inject your own client.

## Creating

```ruby
label = Clubhouse::Label.new(name: "Label One")
label.save
```

Once saved the label object will be reloaded with the response from clubhouse so now your new
object will have the created_at and updated_at time that is returned from the API.

### Required Fields
* name


## Updating

```ruby
label = Clubhouse::Label.find(8)

label.name = "Label updated"
label.save # Save works for both creating and updating

=> <#Clubhouse::Label:0x007fb161230438 @name="Label updated" ... >

```

## Deleting by id

When an empty hash is returned this means it was successfull otherwise it will raise an exception

```ruby
Clubhouse::Label.delete(8)

=> {}
```

## Listing

Returns a list of all labels

```ruby
Clubhouse::Label.all

=> [#<Clubhouse::Label:0x007fb142440458 @name="PT"...>]
```
