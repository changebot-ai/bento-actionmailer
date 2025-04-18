require_relative 'test_helper'

class DeliveryMethodTest < Minitest::Test
  def setup
    @settings = { site_uuid: 'uuid', publishable_key: 'pub', secret_key: 'sec' }
    @delivery_method = BentoActionMailer::DeliveryMethod.new(@settings)
  end

  # Helper to build a Mail::Message with optional html and text parts
  def build_mail(html: nil, text: nil)
    mail = ::Mail::Message.new
    mail.to = 'to@example.com'
    mail.from = 'from@example.com'
    mail.subject = 'Subject'
    if text
      text_part = ::Mail::Part.new do
        content_type 'text/plain; charset=UTF-8'
        body text
      end
      mail.text_part = text_part
    end
    if html
      html_part = ::Mail::Part.new do
        content_type 'text/html; charset=UTF-8'
        body html
      end
      mail.html_part = html_part
    end
    mail
  end

  def test_deliver_raises_when_no_html
    mail = build_mail(text: 'just text')
    assert_raises BentoActionMailer::DeliveryMethod::DeliveryError do
      @delivery_method.deliver!(mail)
    end
  end

  def test_deliver_sends_request_when_html_present
    mail = build_mail(html: '<p>hello</p>')
    mock_http = Minitest::Mock.new
    mock_http.expect(:request, :fake_response, [Net::HTTP::Post])
    Net::HTTP.stub :start, ->(_host, _port, _opts, &block) { block.call(mock_http) } do
      response = @delivery_method.deliver!(mail)
      assert_equal :fake_response, response
    end
    mock_http.verify
  end

  def test_deliver_prefers_html_when_both_html_and_text
    mail = build_mail(html: '<p>HTML</p>', text: 'text')
    mock_http = Minitest::Mock.new
    mock_http.expect(:request, :fake_response, [Net::HTTP::Post])
    Net::HTTP.stub :start, ->(_host, _port, _opts, &block) { block.call(mock_http) } do
      response = @delivery_method.deliver!(mail)
      assert_equal :fake_response, response
    end
    mock_http.verify
  end
end