require 'aliyun/sts'

module AliyunMail

  module Base

    # 设置公共参数
    # @param [Hash] params
    # @return [Hash]
    def self.set_common_params(params)
      params.merge!({
                        'Format' => 'JSON',
                        'Version' => '2015-11-23',
                        'SignatureMethod' => 'HMAC-SHA1',
                        'SignatureVersion' => '1.0',
                        'Timestamp' => Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ'),
                        'SignatureNonce' => SecureRandom.uuid.to_s
                    })
    end

    # 设置key id
    # @param [Hash] params
    # @param [String] key_id
    # @return [Hash]
    def self.set_key_id(params, key_id)
      params.merge!({'AccessKeyId' => key_id})
    end

    # 设置signature
    # @param [String] method
    # @param [Hash] params
    # @param [String] key
    # @return [Hash]
    def self.set_signature(method, params, key)
      cano_query = params.sort.map { |k, v| [escape(k), escape(v)].join('=') }.join('&')
      string_to_sign = method + '&' + escape('/') + '&' + escape(cano_query)
      signature = Base64.strict_encode64(OpenSSL::HMAC.digest('sha1', key + '&', string_to_sign))
      params.merge!({'Signature' => signature})
    end

    # 自定义的escape，根据阿里云的文档，与标准的urlencode稍有不同
    # @param [String] str
    # @return [String]
    def self.escape(str)
      str = CGI.escape(str)
      str = str.gsub("\+", '%20')
      str = str.gsub("\*", '%2A')
      str.gsub("%7E", '~')
    end

    # 获取阿里云邮件url
    # @return [Uri]
    def get_mail_url()
      URI.parse('https://dm.aliyuncs.com/')
    end
  end
end