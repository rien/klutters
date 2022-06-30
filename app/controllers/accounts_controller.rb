class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy sync]
  before_action :set_tilisy, only: %i[sync]

  # GET /accounts or /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1 or /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts or /accounts.json
  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to account_url(@account), notice: "Account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    if @account.update(account_params)
      redirect_to account_url(@account), notice: "Account was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy

    redirect_to accounts_url, notice: "Account was successfully destroyed."
  end

  def sync
    @tilisy.fetch_balance(@account)
    @tilisy.fetch_transactions(@account)

    redirect_back_or_to account_url(@account)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:full_name, :short_name, :color, :bank, :country)
    end
end
