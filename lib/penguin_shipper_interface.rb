class PenguinShipperInterface
  COUNTRY = "US"

  PENGUIN_ALL_RATES_URI   = "http://localhost:4000/get_all_rates"

  def self.make_packages(grouped_items)
    origin_package_pairs = []
    grouped_items.each do |merchant, items|
      origin_package = {}
      origin_package["origin"] = create_location(merchant)
      origin_package["packages"] = []
      items.each do |item|
        origin_package["packages"] << create_package(item)
      end
      origin_package_pairs << origin_package
    end
    origin_package_pairs
  end

  def self.create_location(object)
    location = {}
    location["country"] = COUNTRY
    location["state"] = object.state
    location["city"] = object.city
    location["zip"] = object.zip
    return location
  end

  def self.create_package(item)
    package = {}
    product = item.product
    package["weight"] = product.weight_in_gms

    dimensions = [product.length_in_cms, product.width_in_cms, product.height_in_cms]
    package["dimensions"] = dimensions
    return package
  end

  def self.request_rates_from_API(json_shipment)
    response = HTTParty.get(PENGUIN_ALL_RATES_URI, query: { json_data: json_shipment } )
    response.parsed_response
  end

  def self.request_rates_for_packages(origin_package_pairs, destination)
    all_rates = []

    origin_package_pairs.each do |distinct_origin|
      distinct_origin["destination"] = destination
      shipment = {}
      shipment["shipment"] = distinct_origin

      json_shipment = shipment.to_json

      results = request_rates_from_API(json_shipment)
      all_rates += results
    end
    all_rates
  end

  def self.process_rates(all_rates)
    calculated_rates = []

    grouped_rates = all_rates.group_by { |rate| rate["service_name"] }
    grouped_rates.each do |service, service_rate_pairs|
      rate = {}
      rate["service_name"] = service
      rate["total_price"] = service_rate_pairs.inject(0) { |sum, rate| sum + rate["total_price"] }
      rate["delivery_date"] = service_rate_pairs.last["delivery_date"]
      calculated_rates << rate
    end
    calculated_rates
  end

  def self.process_order(order)
    order_items = order.order_items

    grouped_items = order_items.group_by { |order_item| order_item.product.user }

    origin_package_pairs = make_packages(grouped_items)

    destination = create_location(order)

    all_rates = request_rates_for_packages(origin_package_pairs, destination)

    @calculated_rates = process_rates(all_rates)
  end
end
