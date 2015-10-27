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

        desc "get-buildplans", "gets build plans"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        def get_buildplans
            #uri = URI('https://thesib.atlassian.net/builds/rest/api/latest/plan/TEST-TEST')
            uri = URI('https://thesib.atlassian.net/builds/rest/api/latest/plan')
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_get_request_header
            #req=r.create_post_request_header(false)

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

        desc "get-buildplan", "gets build plans from a specific project"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :plan_key, :type => :string, :required => true
        def get_buildplan
            uri = URI("https://thesib.atlassian.net/builds/rest/api/latest/plan/#{options[:plan_key]}/")
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_get_request_header
            #req=r.create_post_request_header(false)

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

        desc "run-buildplan", "runs a specific build plan"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :build_key, :type => :string, :required => true
        option :stage, :type => :string, :required => false, :default => false
        option :build_number, :type => :string, :required => false, :default => false
        def run_buildplan
            key = options[:build_key]
            #post = 
            key = "#{key}-#{options[:build_number]}" if options[:build_number]
            key = "#{key}?executeAllStages=true" if options[:stage]
            key = "#{key}&os_authType=basic"
            #key = "#{key}?stage=#{options[:stage]}&executeAllStages=true" if options[:stage]
            uri = URI("https://thesib.atlassian.net/builds/rest/api/latest/queue/#{key}")
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_post_request_header(false)

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