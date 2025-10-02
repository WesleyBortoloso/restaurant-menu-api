![Coverage](https://img.shields.io/badge/coverage-99%25-green)
![Status](https://img.shields.io/badge/status-development-blue)
![Ruby](https://img.shields.io/badge/Ruby-3.3.4-red)
![Rails](https://img.shields.io/badge/Rails-7.1.3-red)
![Postgres](https://img.shields.io/badge/Postgres-15.0-informational)

# Restaurant Menu Data Importer

This service allows you to import **Restaurants**, **Menus**, **MenuItems** and **Pricings** directly from a JSON file.

### Import via API

You can upload a JSON file through the provided endpoint:

```bash
curl -X POST http://BASE_URL/api/v1/restaurants/import \
  -F "file=@path/to/restaurant_data.json"
```

The file must be a valid JSON file following the required schema.

Example
```json
{
  "restaurants": [
    {
      "name": "Poppo's Cafe",
      "menus": [
        {
          "name": "Lunch",
          "menu_items": [
            { "name": "Burger", "price": 9 },
            { "name": "Small Salad", "price": 5 }
          ]
        }
      ]
    }
  ]
}
```

To access and request the imported data, consult the endpoins at `/api/swagger_docs/`, you will should see endpoints like: 

- GET /api/v1/restaurants
- GET /api/v1/menus
- GET /api/v1/menu_items

### Developer guide

To setup and execute the project

```ruby
bundle install
rails db:create db:migrate
rails server
```

#### Rules

**Restaurants**
- Identified by `name`.
   - If a restaurant with the same name already exists, it will be reused.

**Menus**
 - Belong to a `Restaurant`.
 - Identified by `name` within the same restaurant.
 - If a menu already exists under the same restaurant, it will be reused.

**Menu Items**
   - Belong to `Menu` and a `Restaurant`.
   - Identified by `name` and `restaurant_id`.
   - If a menu item exists in the same restaurant, it will be reused.

**Pricing**
   - Pricing links a `Menu` and a `MenuItem`.
   - If a pricing exists, it is updated with the new price.
   - If it does not exist, it is created.

**Logging**
   - All operations are displayed in `logs` and returned in the response.
   - Example log entry:
     ```json
     {
       "type": "Pricing",
       "name": "Burger in Lunch",
       "status": "set to 9, at Poppo's Cafe"
     }
     ```