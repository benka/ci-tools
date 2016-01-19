require "jira-automator/version"
require "jira-automator/res/request"
require "jira-automator/res/transition"
require "jira-automator/res/issue"

require "net/http"
require "json"
require "thor"

module JiraAutomator
    
    ##include Resoures
    puts "JIRA issue status automator"
    puts "Version #{VERSION}"

    class Automator < Thor

        desc "get-filters", "gets favourite filters from jira"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :domain, :type => :string, :required => true
        def get_filters
            domain=options[:domain]
            uriString = "https://#{domain}/rest/api/2/filter/favourite"
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
        option :filter_id, :type => :string, :required => true
        option :domain, :type => :string, :required => true
        def get_filterbyID
            filter=options[:filter_id]
            domain=options[:domain]
            uriString = "https://#{domain}/rest/api/2/filter/#{filter}"
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
        option :domain, :type => :string, :required => true
        def get_issues
            filter=options[:filter_name]
            domain=options[:domain]
            uriString = "https://#{domain}/rest/api/2/filter/favourite"
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

        desc "search-issues", "gets issues with the use of JQL search"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :jql, :type => :string, :required => true
        option :transition, :type => :string, :required => false
        option :domain, :type => :string, :required => true
        def search_issues
            filter=options[:filter_name]
            domain=options[:domain]
            uriString = "https://#{domain}/rest/api/2/search"
            uri = URI(uriString)
            jql = options[:jql]

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_post_request_header(jql)

            res = Net::HTTP.start(uri.hostname, 
                :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
            else 
                result=JSON.parse(res.body)
                puts "ISSUES found: #{result["issues"].count}"
                puts "-------------------------------"
                result["issues"].each { |i|
                    puts "KEY: #{i["key"]},  ID: #{i["id"]}"
                    puts "URL: #{i["self"]}"
                    puts "-------------------------------"
                    if options[:transition] 
                        t = Resources::Transition.new(options[:user], options[:pwd])
                        t.get_transitions(i["self"], options[:transition])
                    end
                }
            end
        end

        desc "transition-issues", "set status of all cards wit a specific filter"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :filter_name, :type => :string, :required => true
        option :transition, :type => :string, :required => false
        option :domain, :type => :string, :required => true
        def transition_issues
            filter=options[:filter_name]
            domain=options[:domain]
            @rv=filter
            uriString = "https://#{domain}/rest/api/2/filter/favourite"
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

                result.each { |i|
                    if filter == i["name"]
                        puts "Filter name: #{i["name"]},  ID: #{i["id"]}"
                        puts "Filter URL: #{i["searchUrl"]}"
                        puts "-------------------------------"
                        issue = Resources::Issue.new(options[:user], options[:pwd])
                        issue.transition_issues(i["searchUrl"], options[:transition])
                    end
                }
            end
        end
    end
end