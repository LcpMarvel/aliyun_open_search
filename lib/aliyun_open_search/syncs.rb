module AliyunOpenSearch
  class Syncs < Base
    def initialize(app_name)
      super()

      @base_url = "#{ENV["OPEN_SEARCH_HOST"]}/index/doc/#{app_name}"
    end

    def self.request_method
      "POST"
    end

    def execute(custom_params)
      formatted_custom_params = Base.format_params(custom_params)

      params_with_signature = basic_params.merge(
        "Signature" => Syncs.signature(basic_params.merge(formatted_custom_params))
      )

      Net::HTTP.post_form(uri(params_with_signature), formatted_custom_params)
    end
  end
end
