json.extract! transaction, :id, :amount, :other, :reference, :description, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
