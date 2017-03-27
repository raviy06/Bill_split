class Entry < ApplicationRecord

	belongs_to :user
	has_many :guests, dependent: :destroy

	def self.distribute(entry_id, total_amount, guests_params)
		guests_array = Array.new

		guests_params.each do |guest|
	        amount_should_have_paid = total_amount / guests_params.length.to_f
	        new_friend = Friend.new(guest[:name], guest[:amount_paid].to_f, amount_should_have_paid)
		    Guest.create!(:name => guest[:name], :entry_id => entry_id, :amount_paid => guest[:amount_paid].to_f, :amount_should_have_paid => amount_should_have_paid)		  		  
	      	guests_array.push(new_friend)
	    end
	end
end

class Friend
  attr_accessor :name, :amount_paid, :amount_should_have_paid, :id
  
  def initialize(name, amount_paid, amount_should_have_paid)
    @name = name
    @amount_paid = amount_paid
    @amount_should_have_paid = amount_should_have_paid
  end
  
  def amount_lent
    @amount_paid - @amount_should_have_paid
  end
  
  def amount_owed
    @amount_should_have_paid - @amount_paid
  end
end
