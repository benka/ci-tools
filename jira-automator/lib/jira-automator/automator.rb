require "jira/automator/version"
require "net/http"
require "thor"


module JiraAutomator
    class Automator < Thor

        desc "get-filters", "gets filters from jira"
        def get_filters
            puts "get filters"
           ##uri = URI('https://thesib.atlassian.net/rest/api/2/filter/favourite')
            #res = Net::HTTP.get_response(uri)
           # puts res.code
            #puts res.message
           # puts res.body
        end
    end
end