module JiraAutomator
    module Resources

        class Transition

            def initialize(user, pwd)
                @user = user
                @pwd = pwd
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
                            do_transition(searchUrl, i["id"])
                        end
                        
                    }
                end
            end

            def do_transition(searchUrl, transitionId)

                uri = "#{searchUrl}/transitions"
                uri = URI(uri)
                post = {
                    "transition" => {
                        "id" => transitionId
                    }
                }

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