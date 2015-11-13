module UsersHelper
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    #gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm"
    if user.avatar.blank?
      gravatar_url = "default-avatar.jpg"
    else
      gravatar_url = user.avatar.url
      #gravatar_url = "default-avatar.jpg"
    end
    image_tag(gravatar_url, alt: user.name, class: "gravatar", width: size, height: size)
  end
end
