module BambooAmiManager
    module Resources

        class Request

            def initialize(uri, user, pwd)
                @uri = uri
                @user = user
                @pwd = pwd
            end

            def create_get_request_header
                req = Net::HTTP::Get.new(@uri)
                req.basic_auth @user, @pwd
                req.content_type = 'application/json'
                req.add_field 'X-Atlassian-Token' ,'nocheck'
                return req
            end

            def create_request_header(type, post)
                req = create_post_request_header(post) if type == "post"
                req = create_put_request_header(post) if type == "put"
                return req
            end

            def create_post_request_header(post)
                #puts "Creating POST header"
                req = Net::HTTP::Post.new(@uri)
                req.basic_auth @user, @pwd
                req.content_type = 'application/json'
                req.body = post if post
                return req
            end

            def create_put_request_header(post)
                puts "Creating PUT header"
                req = Net::HTTP::Put.new(@uri)
                req.basic_auth @user, @pwd
                req.content_type = 'application/json'
                req.add_field 'X-Atlassian-Token' ,'nocheck'
                #req.body = "test" #post if post
                return req
            end 
        end
    end
end