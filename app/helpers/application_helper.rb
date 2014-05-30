module ApplicationHelper
  def canonical_url
    "http://#{request.host}#{request.fullpath}"
  end
end
