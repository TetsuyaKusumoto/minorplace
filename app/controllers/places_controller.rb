class PlacesController < ApplicationController
  before_action :logged_in_user , except: [:show]
  before_action :set_place, only: [:show]

  def new
    @place = Place.new
    if request.mobile.present?
      if request.mobile.position.present?
        binding.pry
        @latitude   = request.mobile.position.lat
        @longitude = request.mobile.position.lon
        @hash = ["lat" => @latitude, "lng" => @longitude]
      elsif request.location.present?
        result = request.location
        @hash = ["lat" => result.latitude, "lng" => result.longitude]
      else
        @hash = ["lat" => 36.549959, "lng" => 139.373408]
      end      
    else
      if request.location.present?
        result = request.location
        @hash = ["lat" => result.latitude, "lng" => result.longitude]
      else
        @hash = ["lat" => 36.549959, "lng" => 139.373408]
      end
    end
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
      marker.infowindow render_to_string(:partial => "/places/address_template", :locals => { :place => place})
    end
    @ownership = current_user.visits.find_by( place_id: @place.id)
    @visited_places = Ownership.where(place_id: @place.id, type: "Visit")
    @rank = @place.want_level
#    binding.pry
  end
  def search
    if params[:search].present?
      @searched_places = Place.elasticSearch(params[:search])
      @hash = Gmaps4rails.build_markers(@searched_places) do |place, marker|
        marker.lat place.latitude
        marker.lng place.longitude
#        marker.infowindow place.name
        marker.infowindow render_to_string(:partial => "/places/info_template", :locals => { :place => place})
#        marker.picture({
#           :url => place.photo.url,
#            :width   => "30",
#            :height  => "30"
#        })
      end
    #binding.pry
      
    elsif request.mobile.present?
      if request.mobile.position.present?
        binding.pry
        @latitude   = request.mobile.position.lat
        @longitude = request.mobile.position.lon 
        @hash = ["lat" => @latitude, "lng" => @longitude]
      elsif request.location.present?
        result = request.location
        @hash = ["lat" => result.latitude, "lng" => result.longitude]
      else
        @hash = ["lat" => 35, "lng" => 139.5]
      end

    else
      if request.location.present?
        result = request.location
        @hash = ["lat" => result.latitude, "lng" => result.longitude]
      else
        @hash = ["lat" => 35, "lng" => 139.5]
      end
    end
    #binding.pry
    render 'places/search'
  end
  def create_place_photo
    @ownership = Ownership.new
    render 'places/create_place_photo', locals: { place_id: params[:id] }
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
