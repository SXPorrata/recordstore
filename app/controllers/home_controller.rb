class HomeController < ActionController::API
    def index
        @artists = Artist.all

        render json: @artists
    end
end