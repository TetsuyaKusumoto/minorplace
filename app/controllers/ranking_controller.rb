class RankingController < ApplicationController
  def have
    @rankings_hash = Ownership.where(type: 'Have').select("item_id count_item_id").group("item_id").order('count_item_id desc').limit(10).count("item_id")
    @arr = Array.new(10){ Array.new(7) }
    index = 0
    @rankings_hash.each do |item_id, count|
      @item = Item.find_by(id: item_id)
      @arr[index][0] = item_id
      @arr[index][1] = count
      @arr[index][2] = @item.title
      @arr[index][3] = @item.large_image
      @arr[index][4] = @item.detail_page_url
      @arr[index][5] = @item.description
      @arr[index][6] = (index + 1)
      index += 1
    end 
  end
  def want
    @rankings_hash = Ownership.where(type: 'Want').select("item_id count_item_id").group("item_id").order('count_item_id desc').limit(10).count("item_id")
    @arr = Array.new(10){ Array.new(7) }
    index = 0
    @rankings_hash.each do |item_id, count|
      @item = Item.find_by(id: item_id)
      @arr[index][0] = item_id
      @arr[index][1] = count
      @arr[index][2] = @item.title
      @arr[index][3] = @item.large_image
      @arr[index][4] = @item.detail_page_url
      @arr[index][5] = @item.description
      @arr[index][6] = (index + 1)
      index += 1
    end  
  end
end
