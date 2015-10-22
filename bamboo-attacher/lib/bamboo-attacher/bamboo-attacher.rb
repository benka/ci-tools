require "bamboo-attacher/version"
require "bamboo-attacher/res/request"
require "bamboo-attacher/res/transition"
require "bamboo-attacher/res/issue"

require "net/http"
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
            uri = URI('https://thesib.atlassian.net/bamboo/rest/api/latest')

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_get_request_header

            res = Net::HTTP.start(uri.hostname, 
                :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
            else 
                result=JSON.parse(res.body)

                result.each { |i|
                    puts i
                    #puts "Filter name: #{i["name"]},  ID: #{i["id"]}"
                    #puts "Filter URL: #{i["searchUrl"]}"
                    #puts "-------------------------------"
                }
            end
        end
    end
end