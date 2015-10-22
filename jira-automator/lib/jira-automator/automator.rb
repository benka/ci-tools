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

        desc "get-filters", "gets favourite filters from jira"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        def get_filters
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
                    puts "Filter name: #{i["name"]},  ID: #{i["id"]}"
                    puts "Filter URL: #{i["searchUrl"]}"
                    puts "-------------------------------"
                }
            end
        end

        desc "get-filterbyID", "gets a specific filter from jira by ID"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :filter, :type => :string, :required => true
        def get_filterbyID
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
                puts "Filter name: #{result["name"]},  ID: #{result["id"]}"
                puts "Filter URL: #{result["searchUrl"]}"
                puts "-------------------------------"
            end
        end
        
        desc "get-issues", "gets issues from a specific filter from jira"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :filter_name, :type => :string, :required => true
        def get_issues
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
                        puts "Filter name: #{i["name"]},  ID: #{i["id"]}"
                        puts "Filter URL: #{i["searchUrl"]}"
                        puts "-------------------------------"
                        issue = Resources::Issue.new(options[:user], options[:pwd])
                        issue.get_issues(i["searchUrl"])
                    end
                }
            end
        end

        desc "transition-issues", "set status of all cards wit a specific filter"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :filter_name, :type => :string, :required => true
        option :transition_id, :type => :string, :required => false
        def transition_issues
            filter=options[:filter_name]
            @rv=filter
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
                        puts "Filter name: #{i["name"]},  ID: #{i["id"]}"
                        puts "Filter URL: #{i["searchUrl"]}"
                        puts "-------------------------------"
                        issue = Resources::Issue.new(options[:user], options[:pwd])
                        issue.transition_issues(i["searchUrl"], filter, options[:transition_id])
                    end
                }
            end
        end
    end
end