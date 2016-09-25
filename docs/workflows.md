# Workflows

This assumes that you have setup the default client, or will inject your own client.

## Creating, Updating, Deleting

You can't create, update or delete workflows via the API this needs to happen only via Clubhouse web

## Listing

Returns a list of all workflows

```ruby
Clubhouse::Workflow.all

=> [#<Clubhouse::Workflow:0x007fb142034030 @default_state_id=500000011, @id=500000009...>]
```
