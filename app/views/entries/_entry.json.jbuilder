json.extract! entry, :id, :event, :event_date, :description, :location, :total_amount, :created_at, :updated_at
json.url entry_url(entry, format: :json)
