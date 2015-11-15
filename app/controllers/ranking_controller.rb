class RankingController < ApplicationController
  def visit
    @rankings_hash = Ownership.where(type: 'Visit').select("place_id count_place_id").group("place_id").order('count_place_id desc').limit(10).count("place_id")
    @arr = Array.new(10){ Array.new(7) }
    index = 0
    @rankings_hash.each do |place_id, count|
      @place = Place.find_by(id: place_id)
      @arr[index][0] = place_id
      @arr[index][1] = count
      @arr[index][2] = @place.name
      @arr[index][3] = @place.comment
      @arr[index][4] = @place.photo.url
      @arr[index][5] = (index + 1)
      @arr[index][6] = @place.visits
      index += 1
    end 
  end
  def want
    @rankings_hash = Ownership.where(type: 'Want').select("place_id count_place_id").group("place_id").order('count_place_id desc').limit(10).count("place_id")
    @arr = Array.new(10){ Array.new(7) }
    index = 0
    @rankings_hash.each do |place_id, count|
      @place = Place.find_by(id: place_id)
      @arr[index][0] = place_id
      @arr[index][1] = count
      @arr[index][2] = @place.name
      @arr[index][3] = @place.comment
      @arr[index][4] = @place.photo.url
      @arr[index][5] = (index + 1)
      index += 1
    end  
  end
end
