module AliyunOpenSearch
  class Search < Base
    attr_reader :index_names

    def initialize(*index_names)
      super()

      @index_names = index_names.join(";")
    end

    def execute(custom_params)
      params = basic_params.merge(
        Base.format_params(custom_params.merge("index_name" => index_names))
      )

      Net::HTTP.get(
        uri(params.merge("Signature" => Search.signature(params)))
      )
    end
  end
end
