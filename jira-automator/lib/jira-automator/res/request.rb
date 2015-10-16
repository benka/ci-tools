module JiraAutomator
    module Resources

        class Request

            def initialize(uri, user, pwd)
                puts "WTH"
                @uri = uri
                @user = user
                @pwd = pwd
            end

            def create_request_header
                req = Net::HTTP::Get.new(@uri)
                req.content_type = 'application/json'
                req.add_field 'X-Atlassian-Token' ,'nocheck'
                req.basic_auth @user, @pwd
            end
        end
    end
end