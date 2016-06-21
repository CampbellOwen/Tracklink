class HomeController < ApplicationController
    include SessionsHelper
    def index
        render "index"
    end
    def history
        render "history"
    end
end
