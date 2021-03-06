require "bamboo-amimanager/version"
require "bamboo-amimanager/res/request"

require "net/http"
require "json"
require "thor"

module BambooAmiManager
    
    ##include Resoures
    puts "Bamboo AMI ID manager"
    puts "Version #{VERSION}"

    class AmiManager < Thor

        desc "get-configurations", "gets all elastic image configuration"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :domain, :type => :string, :required => true
        def get_configurations
            domain=options[:domain]
            uriString = "https://#{domain}/builds/rest/api/latest/elasticConfiguration"
            uri = URI(uriString)
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_get_request_header

            res = Net::HTTP.start(uri.hostname,
                :use_ssl => uri.scheme == 'https'
            ) { |http|
                http.request(req)
            }

            if res.code != "200"
                puts "---ERROR---"
                puts res.code
                puts res.message
            else 
                #puts res.body
                result=JSON.parse(res.body)

                result.each { |i|
                    puts i
                    puts "-------------------------------"
                }
            end
        end

        desc "get-configuration-by-id", "get an elastic image configuration by id"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :image_id, :type => :string, :required => true
        option :domain, :type => :string, :required => true
        def get_configuration_by_id
            domain=options[:domain]
            uriString = "https://#{domain}/builds/rest/api/latest/elasticConfiguration/#{options[:image_id]}"
            uri = URI(uriString)
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_get_request_header

            res = Net::HTTP.start(uri.hostname,
                :use_ssl => uri.scheme == 'https'
            ) { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
            else 
                #puts res.body
                result=JSON.parse(res.body)
                puts "Image name: #{result["configurationName"]}"
                puts "AMI ID: #{result["imageId"]}"
                puts "Image configuration id: #{result["configurationId"]}"
            end
        end

        desc "get-configurationid-by-name", "get an elastic image configuration by id"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :image_name, :type => :string, :required => true
        option :domain, :type => :string, :required => true
        def get_configurationid_by_name
            domain=options[:domain]
            image_name=URI.escape(options[:image_name])

            uriString = "https://#{domain}/builds/rest/api/latest/elasticConfiguration/configuration-name/#{image_name}"
            uri = URI(uriString)
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_get_request_header

            res = Net::HTTP.start(uri.hostname,
                :use_ssl => uri.scheme == 'https'
            ) { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
            else 
                #puts res.body
                result=JSON.parse(res.body)
                puts "Image name: #{result["configurationName"]}"
                puts "AMI ID: #{result["imageId"]}"
                puts "Image configuration id: #{result["configurationId"]}"
            end
        end

        desc "set-configurationid-by-name", "get an elastic image configuration by id"
        option :user, :type => :string, :required => true
        option :pwd, :type => :string, :required => true
        option :image_name, :type => :string, :required => true
        option :image_id, :type => :string, :required => true
        option :domain, :type => :string, :required => true
        def set_configurationid_by_name
            domain=options[:domain]
            image_name=URI.escape(options[:image_name])

            uriString = "https://#{domain}/builds/rest/api/latest/elasticConfiguration/configuration-name/#{image_name}"
            uri = URI(uriString)
            puts "URI: #{uri}"

            r = Resources::Request.new(uri, options[:user], options[:pwd])
            req=r.create_get_request_header

            res = Net::HTTP.start(uri.hostname,
                :use_ssl => uri.scheme == 'https'
            ) { |http|
                http.request(req)
            }

            if res.code != "200"
                puts res.code
                puts res.message
            else 
                puts res.body

                result=JSON.parse(res.body)
                puts "Image name: #{result["configurationName"]}"
                puts "AMI ID: #{result["imageId"]}"
                puts "Image configuration id: #{result["configurationId"]}"

                uriStringSet = "https://#{domain}/builds/rest/api/latest/elasticConfiguration/image-id/#{result["imageId"]}?newImageId=#{options[:image_id]}"
                uriSet = URI(uriStringSet)
                puts "URI: #{uriSet}"

                q = Resources::Request.new(uriSet, options[:user], options[:pwd])
                reqSet=q.create_request_header("put", false)

                resSet = Net::HTTP.start(uriSet.hostname,
                    :use_ssl => uriSet.scheme == 'https'
                ) { |http|
                    http.request(reqSet)
                }
                if resSet.code != "200"
                    puts resSet.code
                    puts resSet.message
                else 
                    puts resSet.body
                end
            end
        end

        desc "test", "test"
        option :user, :type => :string, :required => true
        def test
            puts "TEST: #{options[:user]}"

        end
    end
end