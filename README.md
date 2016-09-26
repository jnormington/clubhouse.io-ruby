[![CircleCI](https://circleci.com/gh/jnormington/clubhouse.io-ruby.svg?style=svg)](https://circleci.com/gh/jnormington/clubhouse.io-ruby)

# Clubhouse

This gem is a client library for the Clubhouse v1 API

If you don't know what [Clubhouse](https://clubhouse.io) is, I recommend you check it out, its an awesome project management system in its early days and can only get better.

Their API documentation is at the following address [https://clubhouse.io/api/v1/](https://clubhouse.io/api/v1/) as you will need it for reference.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clubhouse.io-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clubhouse.io-ruby

## Usage

### Setting up a client

Before we start its best to setup a default client if you are just using it with only one token.

You can generate a token for clubhouse by going to the account section and generating a new token

```ruby
Clubhouse.default_client = Clubhouse::Client.new('YOUR_TOKEN_HERE')
```

Now we are ready to start creating stories. In its basic form this is how you create a story

This will create a new story in the first project that is returned from the API in the all projects request.

```ruby
story = Clubhouse::Story.new(name:'My Story', project_id: Clubhouse::Project.all.first.id)
story.save
```

You can check out all the other docs on other resources with examples [here](docs)

* [Epics](docs/epics.md)
* [Files](docs/files.md)
* [Labels](docs/labels.md)
* [Linked-Files](docs/linked_files.md)
* [Projects](docs/projects.md)
* [Story-Links](docs/story_links.md)
* [Stories](docs/stories.md)
  * [Comments](docs/comments.md)
  * [Tasks](docs/tasks.md)
* [Users](docs/users.md)
* [Workflows](docs/workflows.md)


## Contributing

Bug reports and/or pull requests are welcome


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT)
