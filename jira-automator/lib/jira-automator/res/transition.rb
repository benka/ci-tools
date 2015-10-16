module JiraAutomator
    module Resources

        class Transitions

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
            end
        end
    end
end