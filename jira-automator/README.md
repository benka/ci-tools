# Jira::Automator

Jira Automator is a small gem that simplifies calling Jira REST Api to set specific cards' status.

The main reason for this gem is to support Jira Card/Issue status transition from Bamboo after a successful build & deployment.

## Installation

Add this line to your application's Gemfile:

```ruby
cd jira-automator
gem install bundler
bundle install
rake build 
gem install pkg/jira-automator-x.x.x.gem
```

And then execute:

    $ automator

## Commands

    automator get-filterbyID --filter=FILTER --pwd=password --user=USER --domain=DOMAIN
    # gets a specific filter by ID
    # options
     --filter=FILTER # (mandatory) where FILTER is the filter ID
     --pwd=PWD       # (mandatory) password
     --user=USER     # (mandatory) user
     --domain=DOMAIN # (mandatory) domain name for the JIRA server
     
    automator get-filters --pwd=PWD --user=USER --domain=DOMAIN
    # gets favourite filters for the user
    # options
     --pwd=PWD       # (mandatory) password
     --user=USER     # (mandatory) user
     --domain=DOMAIN # (mandatory) domain name for the JIRA server
     
    automator get-issues --filter-name=FILTER_NAME --pwd=PWD --user=USER --domain=DOMAIN
    # gets issues from a specific filter (by filter name)
    # options
     --filter-name=FILTER_NAME # (mandatory) this is the name of the filter
     --pwd=PWD       # (mandatory) password
     --user=USER     # (mandatory) user
     --domain=DOMAIN # (mandatory) domain name for the JIRA server
     
    automator help [COMMAND]                                                     
    # Describe available commands
     
    automator transition-issues --filter-name=FILTER_NAME --pwd=PWD --user=USER --domain=DOMAIN  
    # set status of all issues related to a specific filter to "release"
    # this should be run after a successful deployment
    # options     
     --filter-name=FILTER_NAME # (mandatory) this is the name of the filter
     --pwd=PWD       # (mandatory) password
     --user=USER     # (mandatory) user
     --domain=DOMAIN # (mandatory) domain name for the JIRA server    
    

## Usage

    automator transition-issues --filter-name=FILTER_NAME --pwd=PWD --user=USER --domain=DOMAIN  


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benka/ci-tools/jira-automator


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

