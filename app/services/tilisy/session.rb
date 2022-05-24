class Tilisy::Session
  attr_accessor :conn, :uid

  def initialize(conn, session_uid, session_hash)
    @conn = conn
    @uid = session_uid
    @hash = session_hash
  end

  def accounts

  end
end
