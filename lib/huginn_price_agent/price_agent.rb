module Agents
  require_relative "../pricey/pricey"

  class ProductSearchAgent < Agent
    description <<-MD
      Search for a product across various websites to get the lowest price. 
      Note: to search for a product in Amazon, you need the ASIN number.
    MD

    event_description <<-MD
      Events are a JSON object containing the lowest price of the product with the following format:
        {
          "title": "Artificial Intelligence: A Modern Approach",
          "price": 5,
          "link": "https://ebay.com/aima-agcy36gdi7q3",
          "retailer": "Ebay"
        }

      Price is in dollars.
    MD

    default_schedule "every_1d"

    def working?
      true
    end

    def default_options
      {
        'keyword' => 'Artificial Intelligence: A Modern Approach'
      }
    end

    def validate_options
      errors.add(:base, "keyword is required") unless options['keyword'].present?
    end

    def check
      create_event :payload => Pricey::ScrapingAgent.new(options['keyword']).get_price
    end
  end
end
