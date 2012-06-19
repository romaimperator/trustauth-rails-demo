module StaticHelper
  def nav_button(url, block)
    return content_tag :li, block, :class => if (request.env["PATH_INFO"] == url) then "active" else "" end
  end
end
