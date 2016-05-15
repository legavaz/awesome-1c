require 'nokogiri'
require 'open-uri'
require 'openssl'

require 'octokit'
require 'faraday-http-cache'

users = []

page = 0 
has_user = true

stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

["bsl", "os"].each do |extension_file|

user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"

while has_user do 
    has_user = false
    page = page + 1
    
    p "Search the " + extension_file + " on page " + page.to_s

    #https://github.com/search?p=1&q=%D0%9F%D1%80%D0%BE%D1%86%D0%B5%D0%B4%D1%83%D1%80%D0%B0+in%3Afile+extension%3Absl&ref=searchresults&type=Code&utf8=%E2%9C%93
    #https://github.com/search?utf8=✓&q=Процедура+in%3Afile+extension%3Absl
    url =  "https://github.com/search?p=" + page.to_s+ "&q=%D0%9F%D1%80%D0%BE%D1%86%D0%B5%D0%B4%D1%83%D1%80%D0%B0+in%3Afile+extension%3A" + extension_file + "&ref=searchresults&type=Code&utf8=%E2%9C%93"
    p url

    selectors = [
        '#code_search_results > div.code-list > div'
    ]

    begin  
        doc = Nokogiri::HTML(open(url,'User-Agent' => user_agent,ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
    rescue
        p "End of page or GitHub ban the search request"
        break
    end

    selectors.each do |selector|
        doc.css(selector).each do |div|
            div.children.each do |child|
              case child.name
                when 'a'
                    has_user = true
                    user = child["href"]  
                    user.slice! "/"
                    
                    p "find the user " + user
                    
                    users.push(user)
                end
            end 
        end
    end
    
    sleep 10
    
end 
end

Octokit.middleware = stack
Octokit.auto_paginate = true

Octokit.configure do |c|
    c.login = ENV['GITHUB_USER']
    c.password = ENV['GITHUB_PASSWORD']
    c.connection_options[:ssl] = { :verify => false }
end

repos_os = []
repos_bsl = []

users.uniq.each do |user|
    
    p "Proces repos for " + user
    
    #Процедура user:allustin in:file extension:bsl
    bls_result = Octokit.search_code("Процедура user:" + user + " in:file extension:bsl")
    
    bls_result["items"].each do |res|
        repos_bsl.push(res["repository"]["full_name"])
    end 
        
    os_result = Octokit.search_code("Процедура user:" + user + " in:file extension:os")
    
    os_result["items"].each do |res|
        repos_os.push(res["repository"]["full_name"])
    end 
    
    sleep 13
    
end

date_time = DateTime.now.strftime("%d/%m/%Y %H:%M\n") 

user_on_markdown = File.expand_path(File.join(File.dirname(__FILE__), "../data/README.md"))

File.open(user_on_markdown,"w") do |f|
  f << "# BSL и OScript репозиторий и их пользователи\n"
  f << "\n"
  f << "" + date_time + "\n"
  f << "\n"
  f << "## Пользователи\n"
  f << "\n"
  f << "Общее количество пользователей: " + users.uniq.size.to_s + "\n"
  f << "\n"
  f << "| Пользователь | Акаунт |\n"
  f << "|---|---|\n"
  users.uniq.each do |user|
    f << "|" + user + "| https://github.com/" + user + " |\n"
  end  
  f << "\n"
  f << "## Репозитории BSL (1C)\n"
  f << "\n"
  f << "Общее количество репозиториев: " + repos_bsl.uniq.size.to_s + "\n"
  f << "\n"
  f << "| Репозиторий | URL |\n"
  f << "|---|---|\n"
  repos_bsl.uniq.each do |repo|
    f << "|" + repo + "| https://github.com/" + repo + " |\n"
  end  
  f << "\n"
  f << "## Репозитории OS (1Script)\n"
  f << "\n"
  f << "Общее количество репозиториев: " + repos_os.uniq.size.to_s + "\n"
  f << "\n"
  f << "| Репозиторий | URL |\n"
  f << "|---|---|\n"
  repos_os.uniq.each do |repo|
    f << "|" + repo + "| https://github.com/" + repo + " |\n"
  end  
  f << "\n"
end




