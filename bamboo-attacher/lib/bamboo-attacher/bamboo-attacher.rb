require "bamboo-attacher/version"
require "bamboo-attacher/res/request"
require "bamboo-attacher/res/transition"
require "bamboo-attacher/res/issue"

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
            uri = URI('https://thesib.atlassian.net/builds/rest/api/latest/queue/TEST-TEST')
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            #req=r.create_get_request_header
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
                #result = XmlSimple.xml_in res.body
                #puts result.keys
                #plans = result["plans"]
                #puts "PLANS: #{plans}"
                #plan = plans[0]["plan"]
                #plan.each { |i| 
                #    puts "Shortkey: #{i["shortKey"]}, Key: #{i["key"]}"
                #    puts "PlanKey: #{i["planKey"]}"
                #    puts "Shortname: #{i["shortName"]}"
                #    puts "Name: #{i["name"]}"
                #    puts "Link: #{i["link"]}"
                #    puts i
                #    puts "-------------------------------"
                }
            end
            end

        end
    end
end