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

  def authorize_url_for(account, session_duration: 90.days)
    state_token = account.generate_link_state_token
    response = conn.post('/auth') do |req|
      req.body = {
        access: {
          valid_until: Time.now.to_i + session_duration,
        },
        aspsp: {
          name: account.bank,
          country: account.country,
        },
        state: state_token,
        redirect_url: callback_accounts_url
      }
    end

    if response.status == 200
      response.body[:url]
    else
      raise Tilisy::Error.new("Error while requesting auth URL: #{response.body}")
    end
  end

  def session_for_code(code)
    response = conn.post('/sessions') do |req|
      req.body = {
        code: code
      }
    end

    if response.status == 200
      Tilisy::Session(conn, response.body)
    else
      raise Tilisy::Error.new("Error while requesting session: #{response.body}")
    end
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
