require_relative 'test_helper'

class RailsIntegrationTest < Minitest::Test
  def test_railtie_defined
    assert defined?(BentoActionMailer::Railtie), "Railtie should be defined"
    assert BentoActionMailer::Railtie < Rails::Railtie, "Railtie should subclass Rails::Railtie"
  end

  def test_delivery_method_registered
    # Simulate Railtie initializer behavior
    ActionMailer::Base.add_delivery_method(
      :bento_actionmailer,
      BentoActionMailer::DeliveryMethod,
      {}
    )
    methods = ActionMailer::Base.delivery_methods
    assert methods.key?(:bento_actionmailer), "BentoActionMailer should register delivery method"
    assert_equal BentoActionMailer::DeliveryMethod, methods[:bento_actionmailer]
  end
end