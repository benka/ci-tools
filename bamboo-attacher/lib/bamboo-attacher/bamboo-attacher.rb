require "bamboo-attacher/version"
require "bamboo-attacher/res/request"

require "net/http"
require "xmlsimple"
require "json"
require "thor"

module BambooAttacher
    
    ##include Resoures
    puts "Bamboo build task attacher"
    puts "Version #{VERSION}"

    class Attacher < Thor

        desc "get-plans", "gets build plans"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        def get_plans
            uri = URI('https://thesib.atlassian.net/builds/rest/api/latest/plan')
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_get_request_header

            res = Net::HTTP.start(uri.hostname,
                :use_ssl => uri.scheme == 'https'
            ) { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
            else 
                #puts res.body
                result = XmlSimple.xml_in res.body
                puts result.keys
                plans = result["plans"]
                puts "PLANS: #{plans}"
                plan = plans[0]["plan"]
                plan.each { |i| 
                    puts "Shortkey: #{i["shortKey"]}, Key: #{i["key"]}"
                    puts "PlanKey: #{i["planKey"]}"
                    puts "Shortname: #{i["shortName"]}"
                    puts "Name: #{i["name"]}"
                    puts "Link: #{i["link"]}"
                    puts i
                    puts "-------------------------------"
                }
            end
        end

        desc "get-plan_bykey", "gets build plans from a specific project"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :plan_key, :type => :string, :required => true
        def get_plan_bykey
            uri = URI("https://thesib.atlassian.net/builds/rest/api/latest/plan/#{options[:plan_key]}/")
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_get_request_header

            res = Net::HTTP.start(uri.hostname,
                :use_ssl => uri.scheme == 'https'
            ) { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
            else 
                puts res.body
                result = XmlSimple.xml_in res.body
                puts result
            end
        end

        desc "run-build", "runs a specific build plan"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :build_key, :type => :string, :required => true
        option :build_number, :type => :string, :required => false, :default => false
        option :all_stages, :type => :boolean, :required => false, :default => false
        def run_build
            key = options[:build_key]
            key = "#{key}-#{options[:build_number]}" if options[:build_number]
            key = "#{key}?executeAllStages=#{options[:all_stages]}" if options[:all_stages]
            uri = URI("https://thesib.atlassian.net/builds/rest/api/latest/queue/#{key}")
            puts "URI: #{uri}"

            type = "post"
            type = "put" if options[:build_number]

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req = r.create_request_header(type, false)

            res = Net::HTTP.start(uri.hostname,
                :use_ssl => uri.scheme == 'https'
            ) { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
            else 
                puts res.body
            end
        end

        desc "run-build-stage", "runs a specific stage in a specific build plan"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :build_key, :type => :string, :required => true
        option :stage, :type => :string, :required => false, :default => false
        option :build_number, :type => :string, :required => false, :default => false
        def run_build_stage
            key = options[:build_key]

            key = "#{key}-#{options[:build_number]}" if options[:build_number]
            key = "#{key}?stage=#{options[:stage]}" if options[:stage]

            uri = URI("https://thesib.atlassian.net/builds/rest/api/latest/queue/#{key}")
            puts "URI: #{uri}"

            type = "post"
            type = "put" if options[:build_number]

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req = r.create_request_header(type, false)

            res = Net::HTTP.start(uri.hostname,
                :use_ssl => uri.scheme == 'https'
            ) { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
            else 
                puts res.body
            end
        end
    end
end