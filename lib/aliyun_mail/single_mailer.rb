require 'aliyun_mail'

module AliyunMail

  class SingleMailer

    include Base

    # 构造
    # @param [String] account_name 命名遵从阿里云文档，实际上就是发信人的地址
    # @param [String] key_id 阿里云的access key
    # @param [String] secret 阿里云的access secret
    def initialize(account_name, key_id, secret)
      super()
      @params = {}
      @secret = secret
      set_account_name account_name
      Base::set_key_id @params, key_id
      Base::set_common_params @params
      set_base_params
    end

    # 发送邮件
    # @return [FalseClass/TrueClass]
    def send()
      Base::set_signature('POST', @params, @secret)
      res = Net::HTTP.post_form(get_mail_url, @params)
      res.code == Net::HTTPOK
      res.is_a?(Net::HTTPSuccess)
    end

    # 添加收信地址
    # @param [Array] addrs
    # @return [self]
    def add_dst_addrs(addrs)
      addr_str = addrs.join(',')
      unless addr_str.empty?
        @params['ToAddress'] += ',' unless @params['ToAddress'].empty?
        @params['ToAddress'] += addr_str
      end
      self
    end

    # 设置发信人昵称
    # @param [String] nick_name
    # @return [self]
    def set_src_alias(nick_name)
      @params.merge!({"FromAlias" => nick_name})
      self
    end

    # 设置邮件主题
    # @param [String] subject
    # @return [self]
    def set_subject(subject)
      @params.merge!({"Subject" => subject})
      self
    end

    # 设置邮件html正文
    # @param [String] html_body
    # @return [self]
    def set_html_body(html_body)
      @params.merge!({"HtmlBody" => html_body})
      self
    end

    # 设置邮件text正文
    # @param [String] text_body
    # @return [self]
    def set_text_body(text_body)
      @params.merge!({"TextBody" => text_body})
      self
    end

    private
    # 设置发信地址
    # @param [String] account_name
    # @return [Hash]
    def set_account_name(account_name)
      @params.merge!({"AccountName" => account_name})
    end

    # 设置基础参数
    # @return [Hash]
    def set_base_params()
      @params.merge!({
                         'Action' => 'SingleSendMail',
                         'ReplyToAddress' => 'false',
                         'AddressType' => '0',
                         'ToAddress' => ''
                     })
    end
  end
end