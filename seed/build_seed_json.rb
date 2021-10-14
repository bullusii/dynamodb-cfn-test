#!/usr/bin/env ruby

require 'securerandom'
require 'time'
require 'date'
require 'json'
require 'FileUtils'

def generate_data()
    item_hash_array = []
    (1..12).each do |month|
        number_of_updates = rand(1..10)
        price_array = generate_prices(number_of_updates)
        price_array.each do |price|
            item_hash_array << generate_item(month, price)
        end
    end

    ## BULK IMPORT ONLY ALLOWS 25 at a time
    chunks = item_hash_array.each_slice(25).to_a
    chunk_num = 0
    chunks.each do |chunk|
        chunk_num += 1
        generate_bulk_request_json(chunk, chunk_num)
    end
end

def generate_item(month, price)
    ##using static 2019
    item = {
        "priceId": {
            "S": SecureRandom.uuid
        },
        "price": {
            "S": price
        },
        "date": {
            "S": generate_date(month)
        }
    }
end

def days_in_month(month, year)
    Date.new(year, month, -1).day
end

def add_leading_zero(number)
    if number < 10
        return "0#{number}"
    else
        return number
    end
end

def generate_date(month)
    daysinmonth = days_in_month(month, 2019)

    day = add_leading_zero(rand(1..daysinmonth))
    month = add_leading_zero(month)
    hour = add_leading_zero(rand(0..24))
    minute = add_leading_zero(rand(0..59))
    second = add_leading_zero(rand(0..59))

    time = "#{hour}:#{minute}:#{second} UTC"
    date_stamp = "2019##{month}##{day}##{time}"
end



def generate_prices(prices)
    price_array = []
    prices.times do |i|
        dollar = rand(2..4)
        cent = rand(0..99)
        ## add leading 0
        cent = "0#{cent}" if cent < 10

        price_array << "#{dollar}.#{cent}"
    end

    price_array
end

def generate_bulk_request_json(items, chunk_num)
    full_file = {}
    full_file['cfnTestPrices'] = []
    items.each do |item|
        item_json = {}
        item_json["PutRequest"] = {}
        item_json["PutRequest"]['Item'] = item

        full_file['cfnTestPrices'] << item_json
    end

    FileUtils.rm_rf('./seed/prices.json') if File.exist?('./dev_setup/prices.json')
    File.open("./seed/prices_seed_#{chunk_num}.json", 'w') { |file| file.write(full_file.to_json) }
end

generate_data()
