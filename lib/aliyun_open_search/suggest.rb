module AliyunOpenSearch
  class Suggest < Base
    attr_reader :index_names

    def initialize(index_names)
      super()
      @base_url = "#{ENV["OPEN_SEARCH_HOST"]}/suggest"
      @index_names = index_names
    end

    def execute(custom_params)
      params = basic_params.merge(
        Base.format_params(custom_params.merge("index_name" => index_names))
      )

      Net::HTTP.get(
        uri(params.merge("Signature" => Suggest.signature(params)))
      )
    end
  end
end
