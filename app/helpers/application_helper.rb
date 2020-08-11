module ApplicationHelper
  def title(*parts)
    content_for(:title){(parts << t(:site_name)).join("-")} unless parts.empty?
  end
end
