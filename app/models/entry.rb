class Entry < ApplicationRecord

	belongs_to :user
	has_many :users, dependent: :destroy

	def self.distribute(entry_id, total_amount, users_params)
		users_array = Array.new

		users_params.each do |user|
	        amount_should_have_paid = total_amount / users_params.length.to_f
	        new_friend = Friend.new(user[:name], user[:amount_paid].to_f, amount_should_have_paid)
		    @user = User.find(user[:user_id])
		    amount_paid = user[:amount_paid].to_f

		    if amount_paid > amount_should_have_paid
	            amount_lent = amount_paid - amount_should_have_paid
	            if !@user.money_lent.nil?
	              current_money_lent = @user.money_lent
	            else
	              current_money_lent = 0
	            end
	            puts "Amount Paid: " + amount_paid.to_s
	            puts "Amount should have Paid: " + amount_should_have_paid.to_s
	            puts "Money Lent: " + amount_lent.to_s
	            @user.update_attributes(:amount_paid => user[:amount_paid].to_f, :amount_should_have_paid => amount_should_have_paid, :money_lent => (current_money_lent + amount_lent))

	          else
	            amount_borrowed = amount_should_have_paid - amount_paid
	            if !@user.money_borrowed.nil?
	              current_money_borrowed = @user.money_borrowed
	            else
	              current_money_borrowed = 0
	            end
	            puts "Amount Paid: " + amount_paid.to_s
	            puts "Amount should have Paid: " + amount_should_have_paid.to_s
	            puts "Money Borrowed: " + amount_borrowed.to_s
       		    @user.update_attributes(:amount_paid => user[:amount_paid].to_f, :amount_should_have_paid => amount_should_have_paid, :money_borrowed => (current_money_borrowed + amount_borrowed))
	          end

		    
	      	users_array.push(new_friend)
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
