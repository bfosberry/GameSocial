class IdentitiesController < ApplicationController
skip_before_filter :verify_authenticity_token  
  def new
    @identity = env['omniauth.identity']
  end
end
