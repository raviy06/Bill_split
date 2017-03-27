class EntriesController < ApplicationController
  
  layout 'entries'

  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.all
    @overall_balance = current_user.money_lent - current_user.money_borrowed
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @guests = @entry.guests
  end

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(entry_params)

    respond_to do |format|
      if @entry.save

        params[:entry][:guests][0][:name] = current_user.email unless current_user.guest?
        Entry.distribute(@entry.id, params[:entry][:total_amount].to_i, params[:entry][:guests])

        amount_paid = params[:entry][:guests][0][:amount_paid].to_f
        amount_should_have_paid = params[:entry][:total_amount].to_i/params[:entry][:guests].length.to_f
        
          
          if amount_paid > amount_should_have_paid
            money_lent = amount_paid - amount_should_have_paid
            if !current_user.money_lent.nil?
              current_money_lent = current_user.money_lent
            else
              current_money_lent = 0
            end
            puts "Amount Paid: " + amount_paid.to_s
            puts "Amount should have Paid: " + amount_should_have_paid.to_s
            puts "Money Lent: " + money_lent.to_s
            current_user.update_attributes(:money_lent => (current_money_lent + money_lent))
          else
            money_borrowed = amount_should_have_paid - amount_paid
            if !current_user.money_borrowed.nil?
              current_money_borrowed = current_user.money_borrowed
            else
              current_money_borrowed = 0
            end
            puts "Amount Paid: " + amount_paid.to_s
            puts "Amount should have Paid: " + amount_should_have_paid.to_s
            puts "Money Borrowed: " + money_borrowed.to_s
            current_user.update_attributes(:money_borrowed => (current_money_borrowed + money_borrowed))
          end
        
          

        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to entries_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:event, :event_date, :description, :location, :total_amount, :user_id)
    end
end
