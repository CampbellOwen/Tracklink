class HomeController < ApplicationController
    include SessionsHelper
    respond_to :json, :html
    
    def index
        render "index"
    end
    def history
        render "history"
    end
end
