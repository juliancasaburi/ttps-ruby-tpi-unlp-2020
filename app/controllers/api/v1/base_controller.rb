class Api::V1::BaseController < Api::BaseController
  before_action do
    self.namespace_for_serializer = ::Api::V1
  end

  private

  def sanitize(string)
    string.gsub(/[^0-9A-Za-z.\-]/, '_').downcase
  end
end
