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


## Commands

     
    bamboo-attacher get-plan_bykey --plan-key=PLAN_KEY --pwd=PWD --user=USER --domain=DOMAIN
    # gets build plans from a specific project
    # options
     --plan-key=PLAN_KEY      # this is the PLAN KEY for the specific plan
     --pwd=PWD
     --user=USER
     --domain=DOMAIN          # domain name of the Bamboo server (or IP)
     
    bamboo-attacher get-plans --pwd=PWD --user=USER --domain=DOMAIN  
    # gets all build plans for the user (first 25)
    # options
     --pwd=PWD 
     --user=USER 
     --domain=DOMAIN          # domain name of the Bamboo server (or IP)
     
    bamboo-attacher help [COMMAND]  
    # Describe available commands or a specific
     
    bamboo-attacher run-build --build-key=BUILD_KEY --pwd=PWD --user=USER --domain=DOMAIN
    # runs a specific build plan
    # options
     --build-key=BUILD_KEY    # this is the PLAN's KEY
     --pwd=PWD
     --user=USER
     --domain=DOMAIN          # domain name of the Bamboo server (or IP)
     --build_number=FALSE     # a build _number_ can be specified, 
                              # so instead of starting a new one build
                              # bamboo-attacher will continue an already started plan
     --all_stages=FALSE       # should it build all stages?
      
    bamboo-attacher run-build-stage --build-key=BUILD_KEY --pwd=PWD --user=USER --domain=DOMAIN
    # runs a specific stage in a specific build plan
    # options
     --build-key=BUILD_KEY    # this is the PLAN's KEY
     --pwd=PWD
     --user=USER
     --domain=DOMAIN          # domain name of the Bamboo server (or IP)
     --build_number=FALSE     # a build _number_ can be specified, 
                              # so instead of starting a new one build
                              # bamboo-attacher will continue an already started plan
     --stage=FALSE            # name of a stage to start within a plan

  
## Usage

    bamboo-attacher run-build-stage --build-key=BUILD_KEY --pwd=PWD --user=USER --domain=DOMAIN --build_number=x --stage="next stage"
    
Most of the options are existing `environment variables` that Bamboo sets on the server when running a build, so it is easy to feed into `bamboo-attacher`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benka/bamboo-attacher.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
