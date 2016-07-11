class HomeController < ApplicationController
    include SessionsHelper
    respond_to :json, :html
    
    def index
        render "index"
    end
    def stop
        @stop = Stop.find_by(StopNo: params[:StopNo])
        respond_with(@stop)
    end
    def history
        render "history"
    end
end
