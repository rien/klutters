#noinspection RubyClassVariableUsageInspection
class Tilisy::Api

  include Rails.application.routes.url_helpers

  def conn
    @conn ||= new_connection
  end

  def application
    conn.get('/application').body
  end

  def aspsps
    conn.get('/aspsps').body
  end

  def authorize_url_for(session, session_duration: 90.days)
    state_token = session.generate_link_state_token!
    response = conn.post('/auth') do |req|
      req.body = {
        access: {
          valid_until: Time.now.to_i + session_duration,
        },
        aspsp: {
          name: session.bank,
          country: session.country,
        },
        state: state_token,
        redirect_url: callback_sessions_url
      }
    end

    if response.status == 200
      response.body[:url]
    else
      raise Tilisy::Error.new("Error while requesting auth URL: #{response.body}")
    end
  end

  def redeem_session_code(session, code)
    response = conn.post('/sessions') do |req|
      req.body = {
        code: code
      }
    end

    if response.status == 200
      session.activate_with(response.body)

      session.accounts.each do |account|
        fetch_balance(account)
      end
    else
      raise Tilisy::Error.new("Error while requesting session: #{response.body}")
    end
  end

  def fetch_balance(account)
    response = conn.get("/accounts/#{ account.uid }/balances") do |req|
      req.headers['psu-geo-location'] = "0.0,0.0"
    end

    if response.status == 200
      account.update_balance_with(response.body[:balances])
    else
      raise Tilisy::Error.new("Error while requesting balance: #{response.body}")
    end
  end

  def fetch_transactions(account)
    continuation_key = nil

    begin
      response = conn.get("/accounts/#{ account.uid }/transactions") do |req|
        req.headers['psu-geo-location'] = "0.0,0.0"
        req.headers['continuation-key'] = continuation_key
      end

      if response.status == 200
        continuation = response.body[:continuation_key]
        updated = account.update_transactions_with(response.body[:transactions])
      else
        raise Tilisy::Error.new("Error while requesting transactions: #{response.body}")
      end

    end while continuation.present? && updated > 0
  end

  private

  def new_connection
    jwt_key = OpenSSL::PKey::RSA.new(Rails.application.credentials[:tilisy][:key])
    application_id = Rails.application.credentials[:tilisy][:application_id]
    url = URI(Rails.application.config.tilisy_api_url)
    Faraday::new(url.to_s) do |c|
      c.adapter   Faraday.default_adapter

      #c.request   :multipart
      c.request   :json

      c.use       Faraday::FollowRedirects::Middleware

      c.response  :json, parser_options: { symbolize_names: true}
      c.request   :authorization, 'Bearer', -> {
        iat = Time.now.to_i
        jwt_alg = 'RS256'
        jwt_header = {
          typ: 'JWT',
          alg: jwt_alg,
          kid: application_id
        }
        jwt_body = {
          iss: Rails.application.config.tilisy_jwt_iss,
          aud: url.host,
          iat: iat,
          exp: iat + Rails.application.config.tilisy_jwt_lifetime
        }
        JWT.encode(jwt_body, jwt_key, jwt_alg, jwt_header)
      }
    end
  end

end
