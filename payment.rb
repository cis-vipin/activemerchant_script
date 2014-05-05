require 'rubygems'
require 'active_merchant'

# Use the TrustCommerce test servers
ActiveMerchant::Billing::Base.mode = :test

gateway = ActiveMerchant::Billing::PaypalGateway.new(
            :login => '---------',
            :password => '---------',
	    :signature =>   '---------------')

# ActiveMerchant accepts all amounts as Integer values in cents
amount = 1000  # $10.00

# The card verification value is also known as CVV2, CVC2, or CID
credit_card = ActiveMerchant::Billing::CreditCard.new(
		:brand               => "Visa",                
		:first_name         => 'Vipin',
                :last_name          => 'Sharma',
                :number             => '4111111111111111',
                :month              => '8',
                :year               => Time.now.year+1,
                :verification_value => '891')

# Validating the card automatically detects the card type
if credit_card.valid?
  # Capture $10 from the credit card
  response = gateway.purchase(amount, credit_card,:ip => "127.0.0.1")
  gateway.capture(amount, response.authorization)
  if response.success?
    puts "Successfully charged $#{sprintf("%.2f", amount / 100)} to the credit card #{credit_card.display_number}"
  else
    #raise StandardError, response.message
    puts response.message
  end
end
