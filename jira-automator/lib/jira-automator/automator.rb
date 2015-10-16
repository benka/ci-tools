require "jira-automator/version"
require "jira-automator/res/request"
require "jira-automator/res/transition"
require "jira-automator/res/issue"

require "net/http"
require "json"
require "thor"

module JiraAutomator
    
    ##include Resoures

    class Automator < Thor

        desc "get-filters", "gets filters from jira"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :filter_name, :type => :string, :required => true
        def get_filters
            filter=options[:filter_name]
            uri = URI('https://thesib.atlassian.net/rest/api/2/filter/favourite')

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
                    if filter == i["name"]
                        puts i["id"]
                        puts i["name"]
                        puts i["searchUrl"]
                        i = Resorces::Issue.new(options[:user], options[:pwd])
                        i.get_issues(i["searchUrl"])
                    end
                }
            end
        end

        desc "get-filter", "gets a specific filter from jira by ID"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :filter, :type => :string, :required => true
        def get_filter
            filter=options[:filter]
            uriString = "https://thesib.atlassian.net/rest/api/2/filter/#{filter}"
            uri = URI(uriString)

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

                puts result["id"]
                puts result["name"]
                puts result["searchUrl"]

            end
        end
    end
end