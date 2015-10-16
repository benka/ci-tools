require "jira-automator/version"
require "net/http"
require "thor"


module JiraAutomator
    class Automator < Thor

        desc "get-filters", "gets filters from jira"
        def get_filters
           uri = URI('https://thesib.atlassian.net/rest/api/2/filter/favourite')
           req = Net::HTTP::Get.new(uri)
           req.basic_auth 'YW5kcmV3OkJhODEwNjE4'
           res = Net::HTTP.get_response(uri)
           puts res.code
           puts res.message
           puts res.body
        end
    end
end