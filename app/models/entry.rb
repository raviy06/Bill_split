class Entry < ApplicationRecord

	has_many :guests
	has_many :users, :through => :guests

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
	            
	            Guest.create!(:entry_id => entry_id, :user_id => user[:user_id], :amount_paid => user[:amount_paid].to_f, :amount_should_have_paid => amount_should_have_paid)
	            @user.update_attributes(:money_lent => (current_money_lent + amount_lent))

	          else
	            amount_borrowed = amount_should_have_paid - amount_paid
	            if !@user.money_borrowed.nil?
	              current_money_borrowed = @user.money_borrowed
	            else
	              current_money_borrowed = 0
	            end
	            
	            Guest.create!(:entry_id => entry_id, :user_id => user[:user_id], :amount_paid => user[:amount_paid].to_f, :amount_should_have_paid => amount_should_have_paid)
       		    @user.update_attributes(:money_borrowed => (current_money_borrowed + amount_borrowed))
	          end

		    
	      	users_array.push(new_friend)
	    end
	end

	def self.settle(user)

		@users = User.all.reject{|x| x == user}
		@amount_paid = 0
		
		@users.each do |u|
			
			money_borrowed =  user.money_borrowed
			if money_borrowed > u.money_lent
				money_borrowed_still_left = money_borrowed - u.money_lent			
				@amount_paid = u.money_lent
				
				puts u.name + " " + "received" + " " + u.money_lent.to_s + " " + " from " + " " + user.name
				u.update_attributes(:money_lent => 0)
				user.update_attributes(:money_borrowed => money_borrowed_still_left)
			elsif u.money_lent > money_borrowed
				money_still_left = u.money_lent - money_borrowed				
				@amount_paid = money_borrowed

				puts u.name + " " + "received" + " " + money_borrowed.to_s + " " + " from " + " " + user.name
				u.update_attributes(:money_lent => money_still_left)
				user.update_attributes(:money_borrowed => 0)
			else money_borrowed == u.money_lent				
				@amount_paid = u.money_lent
				puts u.name + " " + "received" + " " + u.money_lent.to_s + " " + " from " + " " + user.name
				u.update_attributes(:money_lent => 0)
				user.update_attributes(:money_borrowed => 0)
			end
			
			money_borrowed_still_left

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
