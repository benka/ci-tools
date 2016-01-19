module JiraAutomator
    module Resources

        class Issue

            def initialize(user, pwd)
                @user = user
                @pwd = pwd
            end

            def get_issues(searchUrl)
                list_issues(searchUrl, false, false)

            end

            def transition_issues(searchUrl, transition)
                list_issues(searchUrl, true, transition)
            end

            def list_issues(searchUrl, do_transition, transition)
                uri = URI("#{searchUrl}&maxResults=200")
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
                    puts "Number of issues: #{result["issues"].count}"                    
                    result["issues"].each { |i| 
                        puts "Issue KEY: #{i["key"]},  ID: #{i["id"]}"
                        puts "URL: #{i["self"]}"
                        puts "-------------------------------"
                        if do_transition
                            t = Resources::Transition.new(@user, @pwd)
                            t.get_transitions(i["self"], transition)
                        end
                    }
                end
            end
        end
    end
end