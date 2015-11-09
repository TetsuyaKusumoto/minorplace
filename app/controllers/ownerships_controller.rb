class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    #binding.pry
    @ownership = Ownership.new(ownership_params)
    #binding.pry
    if params[:place_id]
      @ownership.place_id = params[:place_id]
      #@ownership.photo = params[:photo]
      #@ownership.comment = params[:comment]
      #binding.pry
     # @place = Place.find_or_initialize_by(id: params[:id])
    else
      @place = Place.find(params[:place_id])
    end
    @place = Place.find(params[:place_id])
    
    #binding.pry
    if params[:type] == 'Visit'
      current_user.visit(@ownership) 
      redirect_to @place
    else
      current_user.want(@ownership)
    end
  end
  def new
#    @ownership = Ownership.new
#    @ownership.place_id = params[:id]
  end
  def destroy
    @place = Place.find(params[:place_id])
    #binding.pry
    # TODO 紐付けの解除。 
    # params[:type]の値ににVisitdボタンが押された時には「Visit」,
    # Wantedボタンがされた時には「Want」が設定されています。
    if params[:type] == 'Visit'
      current_user.unvisit(@place)
    else
      current_user.unwant(@place)
    end
  end
  def ownership_params
    
    params.fetch(:ownership, {}).permit(:place_id, :type,  :photo, :comment)
  end
end
