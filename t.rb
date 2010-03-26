
require 'pp'
require 'config/environment'

card = ActiveMerchant::Billing::CreditCard.new(:number => "4228349207820084", :month => 6, :year => 2011, :verification_value => "724")
address = { :address1 => "319 NE 191st", :zip => "98155" }
amount = 500

puts "EDD Gateway: "
pp $edd_gateway.purchase amount, card, :billing_address => address

#puts
#puts "PSRC Gateway: "
#pp $psrc_gateway.purchase amount, card, :billing_address => address
