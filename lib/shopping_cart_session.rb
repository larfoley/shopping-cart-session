require "shopping_cart_session/version"
require 'json'

module ShoppingCartSession
  class Error < StandardError; end

  class Cart
    def initialize(session)
      @session = session
      @items = session.key?(:cart_items) ? deserialize_json_objects(session[:cart_items]) : []
      @items = @items.map { |item|
        item["amount"] = item["amount"].to_i
        item["price"] = item["price"].to_f
        item
      }
      @total_price = @items.reduce(0) { |sum, item| sum + item["price"].to_f * item["amount"] }
    end

    def add(product, amount = 1)
      @total_price += product["price"].to_f

      products = @items.select { |p| p["id"].to_s == product.id.to_s }

      if products.length > 0 then
        products.first["amount"] += 1
      else
        @items.push({
          :id => product.id,
          :name => product.name,
          :price => product.price,
          :amount => amount
        })
      end

      update_session
    end

    def empty
      @session[:cart_items] = ""
      @items = []
      @total_price = 0
    end

    def remove(product)
      @total_price -= product["price"].to_f

      item = find_item(product)

      if item and item["amount"].to_i > 1 then
        item["amount"] -= 1
      else
        @items = @items.reject { |item| item["id"].to_s == product["id"].to_s }
      end

      update_session
    end

    attr_reader :total_price, :items

    private

    def find_item(product)
      @items.select { |item| item["id"].to_s == product["id"].to_s }.first
    end

    def deserialize_json_objects(json_string)
      split_json = json_string.gsub('[', '').gsub(']', '').split('}')
      hash_list = []

      for json_hash in split_json do

        json_hash = json_hash.gsub('{', '')

        if json_hash[0] == "," then
          json_hash[0] = ''
        end

        key_value_pairs = json_hash.split(',')

        parsed_hash = {}

        for kv in key_value_pairs do
          key_value = kv.split(':')

          key = key_value[0].gsub('"', '')
          value = key_value[1].gsub('"', '')

          parsed_hash[key] = value
        end
        hash_list.push(parsed_hash)
      end

      return hash_list
    end

    def update_session
      @session[:cart_items] = @items.to_json
    end
  end
end
