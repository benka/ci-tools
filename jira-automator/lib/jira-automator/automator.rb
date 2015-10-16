require "jira-automator/version"
require "net/http"
require "json"
require "thor"

Dir[File.dirname(__FILE__) + '/res/*.rb'].each {|file| require file }

module JiraAutomator
    class Automator < Thor

        desc "get-filters", "gets filters from jira"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :filter_name, :type => :string, :required => true
        def get_filters
            #puts options
            user=options[:user]
            pwd=options[:pwd]
            filter=options[:filter_name]

            uri = URI('https://thesib.atlassian.net/rest/api/2/filter/favourite')

            r = Resources::Request.new(uri, user, pwd)
            #req=r.create_request_header
            #req = Net::HTTP::Get.new(uri)
            
            #req.basic_auth user, pwd
            #req.content_type = 'application/json'
            #req.add_field 'X-Atlassian-Token' ,'nocheck'

            res = Net::HTTP.start(uri.hostname, 
                :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
                #puts res.body
            else 
                result=JSON.parse(res.body)

                result.each { |i|
                    #puts i["name"]
                    if filter == i["name"]
                        puts i["id"]
                        puts i["name"]
                        puts i["searchUrl"]

                    end
                }
            end
        end

        desc "get-filter", "gets a specific filter from jira by ID"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :filter, :type => :string, :required => true
        def get_filter
            #puts options
            user=options[:user]
            pwd=options[:pwd]
            filter=options[:filter]

            uriString = "https://thesib.atlassian.net/rest/api/2/filter/#{filter}"
            uri = URI(uriString)

            req = Net::HTTP::Get.new(uri)
            
            req.basic_auth user, pwd
            req.content_type = 'application/json'
            req.add_field 'X-Atlassian-Token' ,'nocheck'

            res = Net::HTTP.start(uri.hostname, 
                :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
                #puts res.body
            else 
                result=JSON.parse(res.body)

                puts result["id"]
                puts result["name"]
                puts result["searchUrl"]

            end
        end

        def get_filter(user, pwd, searchUrl)

            uri = URI(searchUrl)

            req = Net::HTTP::Get.new(uri)
            
            req.basic_auth user, pwd
            req.content_type = 'application/json'
            req.add_field 'X-Atlassian-Token' ,'nocheck'

            res = Net::HTTP.start(uri.hostname, 
                :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
                #puts res.body
            else 
                result=JSON.parse(res.body)

                puts result["id"]
                puts result["name"]
                puts result["searchUrl"]

            end
        end


    end
end