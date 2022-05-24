class TilisyApi::Account
  def initialize(conn, account_hash)
    @conn = conn
    @account_hash = account_hash
  end
end
