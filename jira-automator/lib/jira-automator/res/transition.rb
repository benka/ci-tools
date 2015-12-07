module JiraAutomator
    module Resources

        class Transition

            def initialize(user, pwd, release_version)
                @user = user
                @pwd = pwd
                @release_version = release_version
            end

            def get_transitions(searchUrl, transition)

                uri = "#{searchUrl}/transitions"
                uri = URI(uri)

                r = Resources::Request.new(uri, @user, @pwd)
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
                    #puts result["transitions"]
                    result["transitions"].each { |i| 
                        #puts "#{i["name"].downcase} vs #{transition.downcase}"
                        if i["name"].downcase == transition.downcase
                            puts "key: #{i['key']}, id: #{i['id']}, transition: #{i['name']}"
                            do_transition(searchUrl, i["id"], transition)
                        end
                        
                    }
                end
            end

            def do_transition(searchUrl, transitionId, transition)

                action = "released"
                if transition.downcase == "deploy"
                    action = "deployed on production"
                end

                uri = "#{searchUrl}/transitions"
                uri = URI(uri)
                post = {
                    "update" => 
                        {"comment" => [
                            {
                                "add" => {
                                    "body" => "This is #{action} in #{@release_version}, setting status to #{transition.upcase} by Bamboo"
                                }
                            }
                        ]},
                    "transition" => {
                        "id" => transitionId
                    }
                }
                #puts post.to_json

                r = Resources::Request.new(uri, @user, @pwd)
                req = r.create_post_request_header(post.to_json)

                res = Net::HTTP.start(uri.hostname, 
                    :use_ssl => uri.scheme == 'https') { |http|
                    http.request(req)
                }
            end
        end
    end
end