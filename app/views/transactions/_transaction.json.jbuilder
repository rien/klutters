json.extract! transaction, :id, :amount, :counterparty, :description, :incurred_at, :effective_at, :transaction_type, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
