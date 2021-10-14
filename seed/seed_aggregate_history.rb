#!/usr/bin/env ruby

require 'securerandom'
require 'time'
require 'date'
require 'json'
require 'FileUtils'


def generate_bulk_request_json(items, chunk_num)
    full_file = {}
    full_file['cfnTestAggregate'] = []
    items.each do |item|
        item_json = {}
        item_json["PutRequest"] = {}
        item_json["PutRequest"]['Item'] = item

        full_file['cfnTestAggregate'] << item_json
    end

    File.open("./seed/agg_seed_#{chunk_num}.json", 'w') { |file| file.write(full_file.to_json) }
end


items = [
    {
        "priceType": {
            "S": "2018#10#MIN"
        },
        "price": {
            "S": "2.74"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2018#10#MAX"
        },
        "price": {
            "S": "2.79"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2018#11#MIN"
        },
        "price": {
            "S": "2.49"
        },
        "date": {
            "S": "2018#11#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2018#11#MAX"
        },
        "price": {
            "S": "2.68"
        },
        "date": {
            "S": "2018#11#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2018#12#MIN"
        },
        "price": {
            "S": "2.44"
        },
        "date": {
            "S": "2018#12#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2018#12#MAX"
        },
        "price": {
            "S": "2.59"
        },
        "date": {
            "S": "2018#12#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#01#MIN"
        },
        "price": {
            "S": "2.39"
        },
        "date": {
            "S": "2019#01#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#01#MAX"
        },
        "price": {
            "S": "2.54"
        },
        "date": {
            "S": "2019#01#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#02#MIN"
        },
        "price": {
            "S": "2.39"
        },
        "date": {
            "S": "2019#02#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#02#MAX"
        },
        "price": {
            "S": "2.57"
        },
        "date": {
            "S": "2019#02#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#03#MIN"
        },
        "price": {
            "S": "2.45"
        },
        "date": {
            "S": "2019#03#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#03#MAX"
        },
        "price": {
            "S": "2.59"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#04#MIN"
        },
        "price": {
            "S": "2.44"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#04#MAX"
        },
        "price": {
            "S": "2.52"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#05#MIN"
        },
        "price": {
            "S": "2.37"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#05#MAX"
        },
        "price": {
            "S": "2.53"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#06#MIN"
        },
        "price": {
            "S": "2.24"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#06#MAX"
        },
        "price": {
            "S": "2.34"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#07#MIN"
        },
        "price": {
            "S": "2.25"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#07#MAX"
        },
        "price": {
            "S": "2.33"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#08#MIN"
        },
        "price": {
            "S": "2.19"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#08#MAX"
        },
        "price": {
            "S": "2.26"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#09#MIN"
        },
        "price": {
            "S": "2.18"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    },
    {
        "priceType": {
            "S": "2019#09#MAX"
        },
        "price": {
            "S": "2.45"
        },
        "date": {
            "S": "2018#10#23#10:10:10 UTC"
        }
    }
]

chunks = items.each_slice(25).to_a
chunk_num = 0
chunks.each do |chunk|
    chunk_num += 1
    generate_bulk_request_json(chunk, chunk_num)
end
