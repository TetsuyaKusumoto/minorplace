class PlacesController < ApplicationController
  before_action :logged_in_user , except: [:show]
  before_action :set_place, only: [:show]

  def new
    @place = Place.new
  end
  def create
    @place = Place.new(place_params)
    @place.create_user_name = current_user.name
    #binding.pry
    if @place.save
      redirect_to @place, notice: "マイナープレイス登録が完了しました"
    else
      render 'new'
    end
  end

  def show
    #@place = Place.find(params[:id])
    @hash = Gmaps4rails.build_markers(@place) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
    end
#    binding.pry
  end
  def search
    @searched_places = Place.search(params[:search])
    @hash = Gmaps4rails.build_markers(@searched_places) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      marker.infowindow place.name
    end
#    binding.pry
    render 'places/search'
  end
  private
  def set_place
    @place = Place.find(params[:id])
  end
  def place_params
    params.require(:place).permit(:name, :address, :latitude,
                                 :longitude, :photo, :comment)
  end
end
