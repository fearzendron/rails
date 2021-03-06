require 'abstract_unit'

class DefaultDeliveryMethodMailer < ActionMailer::Base
end

class NonDefaultDeliveryMethodMailer < ActionMailer::Base
  self.delivery_method = :sendmail
end

class FileDeliveryMethodMailer < ActionMailer::Base
  self.delivery_method = :file
end

class CustomDeliveryMethod
  attr_accessor :custom_deliveries
  def initialize()
    @customer_deliveries = []
  end

  def self.perform_delivery(mail)
    self.custom_deliveries << mail
  end
end

class CustomerDeliveryMailer < ActionMailer::Base
  self.delivery_method = CustomDeliveryMethod.new
end

class ActionMailerBase_delivery_method_Test < Test::Unit::TestCase
  def setup
    set_delivery_method :smtp
  end
  
  def teardown
    restore_delivery_method
  end

  def test_should_be_the_default_smtp
    assert_instance_of ActionMailer::DeliveryMethod::Smtp, ActionMailer::Base.delivery_method
  end
end

class DefaultDeliveryMethodMailer_delivery_method_Test < Test::Unit::TestCase
  def setup
    set_delivery_method :smtp
  end
  
  def teardown
    restore_delivery_method
  end
  
  def test_should_be_the_default_smtp
    assert_instance_of ActionMailer::DeliveryMethod::Smtp, DefaultDeliveryMethodMailer.delivery_method
  end
end

class NonDefaultDeliveryMethodMailer_delivery_method_Test < Test::Unit::TestCase
  def setup
    set_delivery_method :smtp
  end
  
  def teardown
    restore_delivery_method
  end

  def test_should_be_the_set_delivery_method
    assert_instance_of ActionMailer::DeliveryMethod::Sendmail, NonDefaultDeliveryMethodMailer.delivery_method
  end
end

class FileDeliveryMethodMailer_delivery_method_Test < Test::Unit::TestCase
  def setup
    set_delivery_method :smtp
  end

  def teardown
    restore_delivery_method
  end

  def test_should_be_the_set_delivery_method
    assert_instance_of ActionMailer::DeliveryMethod::File, FileDeliveryMethodMailer.delivery_method
  end

  def test_should_default_location_to_the_tmpdir
    assert_equal "#{Dir.tmpdir}/mails", ActionMailer::Base.file_settings[:location]
  end
end

class CustomDeliveryMethodMailer_delivery_method_Test < Test::Unit::TestCase
  def setup
    set_delivery_method :smtp
  end

  def teardown
    restore_delivery_method
  end

  def test_should_be_the_set_delivery_method
    assert_instance_of CustomDeliveryMethod, CustomerDeliveryMailer.delivery_method
  end
end
