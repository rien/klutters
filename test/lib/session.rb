class TilisyApi::Session
  def initialize(conn, session_hash)
    @conn = conn
    @session_hash = session_hash
  end

  def accounts
    @session_hash[:accounts].map do |account_hash|
      TilisyApi::Account.new(@conn, account_hash)
    end
  end
end
