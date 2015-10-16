require "jira-automator/version"
require "net/http"
require "json"
require "thor"

require "jira-automator/res/request"
#Dir[File.dirname(__FILE__) + '/res/*.rb'].each {|file| require file }

module JiraAutomator
    
    include Resources

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
                        get_issues(options[:user], options[:pwd], i["searchUrl"])
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

        def get_issues(user, pwd, searchUrl)

            uri = URI(searchUrl)

            r = Resources::Request.new(uri, user, pwd)
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
                result["issues"].each { |i| 
                    puts i["id"]
                    puts i["key"]
                    puts i["self"]
                    get_transitions(user, pwd, i["self"])
                }
            end
        end

        def get_transitions(user, pwd, searchUrl)

            uri = "#{searchUrl}/transitions"
            uri = URI(uri)

            r = Resources::Request.new(uri, user, pwd)
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
                result["transitions"].each { |i| 
                    if i["name"] == "Release"
                        puts "key: #{i['key']}, id: #{i['id']}, transition: #{i['name']}"
                        do_transition(user, pwd, searchUrl, i["id"])
                    end
                    
                }
            end
        end

        def do_transition(user, pwd, searchUrl, transitionId)

            uri = "#{searchUrl}/transitions"
            uri = URI(uri)
            post = {
                "update" => 
                    {"comment" => [
                        {
                            "add" => {
                                "body" => "This is released, settings status to DONE by Bamboo"
                            }
                        }
                    ]},
                "transition" => {
                    "id" => transitionId
                }
            }
            puts post.to_json

            r = Resources::Request.new(uri, user, pwd)
            req = r.create_post_request_header(post.to_json)

            res = Net::HTTP.start(uri.hostname, 
                :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }

puts res
            #if res.code != "200"
            #    puts res.code
            #    puts res.message
            #else 
            #    result=JSON.parse(res.body)
            #    puts result
            #        puts i["id"]
            #        puts i["name"]

            #end
        end

    end
end