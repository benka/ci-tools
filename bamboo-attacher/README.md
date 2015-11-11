# Bamboo::Attacher

Bamboo Attacher is a small gem that supports _long-running_ Bamboo jobs to run in the background being detached from the Bamboo Agent so it can work on other jobs.

This is only useful if:
    - the job that needs to run in the background can be started using a shell script on the Bamboo server
    - running that specific job in the background will not interfere with other jobs being run by the Agent at the same time.

The process is the following:
- Create a Bamboo plan as usuall
- Create a script on the Bamboo server that will:
    1. run your desired job, and 
    2. at the and it will call bamboo-attacher

- Set up a _script_ task on your Bamboo plan that will `nohup` your script you just set up in the previous step
- Set up a manual stage for your plan
- On the manual stage you can set up a task that displays logs to see if everything went fine in the background 


## Installation

```ruby
cd bamboo-attacher
gem install bundler
bundle install
rake build 
gem install pkg/bamboo-attacher-x.x.x.gem
```


## Usage

TODO: Write usage instructions here


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benka/bamboo-attacher.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).






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


