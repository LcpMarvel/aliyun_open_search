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
      formatted_custom_params = {}.tap do |hash|
        custom_params.map do |key, value|
          hash[key.to_s] =  if value.is_a?(Array)
                              JSON.generate(value)
                            else
                              value.to_s
                            end
        end
      end

      params_with_signature = basic_params.merge(
        "Signature" =>  self.class
                            .signature(basic_params.merge(formatted_custom_params))
      )

      Net::HTTP.post_form(uri(params_with_signature), formatted_custom_params)
    end
  end
end
