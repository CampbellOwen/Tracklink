class HomeController < ApplicationController
    include SessionsHelper
    def index
        render "index"
    end
end
