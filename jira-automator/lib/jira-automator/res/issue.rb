module JiraAutomator
    module Resources

        class Issue

            def initialize(user, pwd)
                @user = user
                @pwd = pwd
            end

            def get_issues(searchUrl)

                uri = URI(searchUrl)

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
                    result["issues"].each { |i| 
                        puts i["id"]
                        puts i["key"]
                        puts i["self"]
                        t = Resources::Transition.new(@user, @pwd)
                        t.get_transitions(i["self"])
                    }
                end
            end
        end
    end
end