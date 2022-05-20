json.extract! account, :id, :name, :bank, :uid, :valid_until, :created_at, :updated_at
json.url account_url(account, format: :json)
