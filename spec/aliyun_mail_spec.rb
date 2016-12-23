require 'spec_helper'

require 'aliyun_mail'

describe AliyunMail do
  it 'has a version number' do
    expect(AliyunMail::VERSION).not_to be nil
  end

  it 'does something useful' do
    mail = AliyunMail::SingleMailer.new 'xxx@xxx.com', 'xxx', 'xxx'
    mail.add_dst_addrs(['ww@ww.com']).set_text_body('test_body').set_src_alias('sl').set_subject('test_subject').send

   mes = AliyunMail1223::SingleMessager.new('xxx','xxx', 'xxx', 'xxxx')
   mes.add_rec_num('12345678910').set_param_string('param_name','param_info').send
  end
end
