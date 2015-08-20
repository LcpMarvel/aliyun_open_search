module AliyunOpenSearch
  class Scan < Base
    attr_reader :request_id, :scroll_id, :scroll_id, :custom_params, :result

    def initialize(index_names, options = {})
      super()

      @index_names = index_names.is_a?(Array) ? index_names.join(";") : index_names
      @scroll = options[:scroll] || "1m"

      @custom_params = {
        query: [
          options[:query] || "query=''",
          "config=hit:#{options[:hit] || 500},format:#{options[:format] || "json"}"
        ]
      }

      setup
    end

    def setup
      params = basic_params.merge(
        Base.format_params(
          custom_params.merge(
            "index_name" => @index_names,
            "scroll" => @scroll,
            "search_type" => "scan"
          )
        )
      )

      send_request(params)
    end

    def execute
      params = Base.new.basic_params.merge(
        Base.format_params(
          custom_params.merge(
            "index_name" => @index_names,
            "scroll" => @scroll,
            "scroll_id" => @scroll_id
          )
        )
      )

      send_request(params)
    end

    private

    def send_request(params)
      @result = Net::HTTP.get(uri(params.merge("Signature" => Search.signature(params))))
      # 为了保持与其他方法返回值一致

      result = JSON.parse(@result)

      @request_id = result["request_id"]
      @scroll_id = result["result"]["scroll_id"]

      self
    end
  end
end
