module UsersHelper
  def gravatar_for user, options = {size: Settings.gravartar.size_default}
    size = options[:size]
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "#{Settings.links.gravartar}#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
