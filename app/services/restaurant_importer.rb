class RestaurantImporter
  attr_reader :data, :logs, :success

  def initialize(file)
    @file = file
    @logs = []
    @data = parse_file
  end

  def call
    return result(false, "Invalid JSON file") unless data
    return result(false, "Invalid JSON data") unless valid_file_structure?
    process_import_data!

  rescue StandardError => e
    Rails.logger.error("RestaurantImporter error: #{e.message}")
    result(false, "Unexpected error")
  end

  private

  def parse_file
    JSON.parse(@file.read)
  rescue JSON::ParserError => e
    Rails.logger.error("RestaurantImporter error: #{e.message}")
  end

  def valid_file_structure?
    data.is_a?(Hash) && data.key?('restaurants')
  end

  def process_import_data!
    ActiveRecord::Base.transaction do
      data['restaurants'].each do |restaurant_data|
        import_restaurant(restaurant_data)
      end
    end
    result(true, "Import finished")
  end

  def import_restaurant(restaurant_data)
    restaurant = Restaurant.find_or_create_by!(name: restaurant_data['name'])

    restaurant_data['menus'].to_a.each do |menu_data|
      import_menu(restaurant, menu_data)
    end
  end

  def import_menu(restaurant, menu_data)
    menu = restaurant.menus.find_or_create_by!(name: menu_data['name'])
    items = menu_data['menu_items'] || menu_data['dishes']
    items.each do |item_data|
      import_item(menu, item_data)
    end
  end

  def import_item(menu, item_data)
    item = find_or_create_menu_item(menu, item_data['name'])
    return unless item.persisted?

    create_or_update_pricing(menu, item, item_data['price'])
  end

  def find_or_create_menu_item(menu, name)
    MenuItem.find_or_initialize_by(name: name, restaurant: menu.restaurant).tap do |item|
      unless item.save
        log("MenuItem", name, "failed: #{item.errors.full_messages.join(', ')}")
      end
    end
  end

  def create_or_update_pricing(menu, item, price)
    Pricing.find_or_initialize_by(menu: menu, menu_item: item).tap do |pricing|
      pricing.price = price
      if pricing.save
        log("Pricing", "#{item.name} in #{menu.name}", "set to #{pricing.price}, at #{menu.restaurant.name}")
      else
        log("Pricing", item.name, "failed: #{pricing.errors.full_messages.join(', ')}")
      end
    end
  end

  def log(type, name, status)
    entry = { type: type, name: name, status: status }
    @logs << entry
  end

  def result(success, message)
    {
      success: success,
      message: message,
      logs: @logs
    }
  end
end
