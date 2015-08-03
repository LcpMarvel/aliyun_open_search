module AliyunOpenSearch
  class Search < Base
    attr_reader :index_names

    def initialize(*index_names)
      super()
      @index_names = index_names.join(";")
      @base_url = "#{ENV["OPEN_SEARCH_HOST"]}/search"
    end

    def execute(custom_params)
      params = basic_params.merge(
        self.class.format_params(custom_params.merge("index_name" => index_names))
      )

      Net::HTTP.get(
        uri(params.merge("Signature" => self.class.signature(params)))
      )
    end
  end
end
