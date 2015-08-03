require "base64"
require "json"

module AliyunOpenSearch
  class Base
    attr_reader :basic_params, :base_url

    def initialize
      @basic_params = {
        "Version" => "v2",
        "AccessKeyId" => ENV.fetch("ACCESS_KEY_ID"),
        "SignatureMethod" => "HMAC-SHA1",
        "Timestamp" => Time.now.utc.iso8601,
        "SignatureVersion" => "1.0",
        "SignatureNonce" => signature_nonce
      }
    end

    def uri(special_base_url = nil, params)
      encoded_params = params.inject([]) do |arr, (k, v)|
        arr << "#{k}=#{CGI.escape(v)}"
      end.join("&")

      URI((special_base_url || base_url) + "?" + encoded_params)
    end

    def self.signature(params)
      params =  params.sort_by { |k, _v| k.to_s }
                .map do |arr|
        str = if arr[1].is_a?(String) || arr[1].is_a?(Fixnum)
                arr[1].to_s
              else
                arr[1].to_json
              end

        "#{arr[0]}=#{CGI.escape(str)}"
      end.join("&")

      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new("sha1"),
          "#{ENV["ACCESS_KEY_SECRET"]}&",
          "POST" + "&" + CGI.escape("/") + "&" + CGI.escape(params)
        )
      ).strip
    end

    private

    def signature_nonce
      # 用户在不同请求间要使用不同的随机数值，建议使用13位毫秒时间戳+4位随机数
      (Time.now.to_f.round(3) * 1000).to_i.to_s + (1000..9999).to_a.sample.to_s
    end
  end
end
