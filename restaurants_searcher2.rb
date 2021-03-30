require 'net/http'
require 'json'
require "csv"

KEYID = "cef819c1cc407aa2"
COUNT = 100
PREF = "Z091"
FREEWORD = "博多駅"
FORMAT = "json"
PARAMS = {"key":KEYID,"count":COUNT,"large_area":PREF,"keyword":FREEWORD,"format":FORMAT}

def write_data_to_csv(params)
    restaurants = [["名称","営業日","住所","最寄駅名"]]
    
    uri = URI.parse("http://webservice.recruit.co.jp/hotpepper/gourmet/v1/")
    uri.query = URI.encode_www_form(PARAMS)
    json_res = Net::HTTP.get uri
    
    response = JSON.load(json_res)
    
    if response.has_key?("error")then
        puts "エラーが発生しました！"
    end
    
    for restaurant in response["results"]["shop"] do
        rest_info = [restaurant["name"], restaurant["open"], restaurant["address"], restaurant["station_name"]]
        puts rest_info
        restaurants.append(rest_info)
    end
    
    CSV.open("restaurants_list.csv", "w") do |csv|
    restaurants.each do |rest_info|
        csv << rest_info
    end
end
return puts restaurants
end

write_data_to_csv(PARAMS)