require 'aliyun_mail'
require 'json'

module AliyunMail

  class SingleMessager
    include Base
    # 构造
    # @param [String] sign_name 短信签名
    # @param [String] template_code 短信模板CODE
    # @param [String] key_id 阿里云的access key
    # @param [String] secret 阿里云的access secret
    def initialize(sign_name,template_code, key_id, secret)
      super() 
      @params = {}
      @secret = secret
      set_sign_name sign_name  #sign_name
      set_template_code template_code #template_code
      set_base_params   #调用set_base_params,version,action,recnum

      Base::set_key_id @params, key_id    
      Base::set_common_params @params  
    end

    # 发送短信
    # @return [FalseClass/TrueClass]
    def send()
      Base::set_signature('POST', @params, @secret)  
      res = Net::HTTP.post_form(get_message_url, @params)   
      res.is_a?(Net::HTTPSuccess) 
    end

    # 添加目标手机号码
    # @param [Array] rec_num
    # @return [self]
    def add_rec_num(rec_num)
      @params.merge!({"RecNum" => rec_num})
      self
    end

    # 设置短信变量
    # @param [String] param_string
    # @return [self]
    def set_param_string(param_string)
      param_string = param_string.to_json
      @params.merge!({"ParamString" => param_string})
      self
    end

    private
    # 设置短信签名
    # @param [String] sign_name
    # @return [Hash]
    def set_sign_name(sign_name)
      @params.merge!({"SignName" => sign_name})
    end

    # 设置短信模板CODE
    # @param [String]  template_code
    # @return [Hash]
    def set_template_code(template_code)
      @params.merge!({"TemplateCode" => template_code})
    end

    # 设置基础参数
    # @return [Hash]
    def set_base_params()
      @params.merge!({
                         'Version' => '2016-09-27', 
                         'Action' => 'SingleSendSms',
                         'RecNum' => ''
                     })
    end

  end #for class

end #for  module