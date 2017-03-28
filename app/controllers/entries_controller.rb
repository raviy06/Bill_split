class EntriesController < ApplicationController
  
  layout 'entries'

  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  before_action :logged_in, only: [:settle, :new, :edit]

  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.all
   # @overall_balance = (current_user.money_lent - current_user.money_borrowed) 
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
    @guests = @entry.guests
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(entry_params)
    
    params[:entry][:user_id] = current_user.id

    respond_to do |format|
      if @entry.save
        Entry.distribute(@entry.id, params[:entry][:total_amount].to_i, params[:entry][:users])

        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end

  end

  def settle
    if money_borrowed?
      Entry.settle(current_user)
      @settlements = Settlement.all.reject{|x| x.payee_id != current_user.id}.last(2)
    else
      redirect_to entries_path
      flash[:notice] = "No settlement to be made."
    end
    

  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    params[:entry][:user_id] = current_user.id
    respond_to do |format|
      if @entry.update(entry_params)
        Entry.distribute(@entry.id, params[:entry][:total_amount].to_i, params[:entry][:users])
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
      params.require(:entry).permit(:event, :event_date, :description, :location, :total_amount, :user_id, :users)
    end

    def money_borrowed?
      if current_user.money_borrowed > 0
        return true
      else
        return false
      end
    end

    def logged_in
      unless user_signed_in?
        redirect_to new_user_session_path
        flash[:notice] = "Please Sign in to continue"
      end
    end

end
