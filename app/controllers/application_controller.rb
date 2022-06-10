class ApplicationController < ActionController::Base

  protected

  def set_tilisy
    @tilisy = Tilisy::Api.new
  end
end
