class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy reload_balance reload_transactions]
  before_action :set_tilisy, only: %i[reload_balance reload_transactions]

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

  def reload_balance
    @tilisy.fetch_balance(@account)

    redirect_to accounts_url, notice: "Account balance updated"
  end

  def reload_transactions
    @tilisy.fetch_transactions(@account)

    redirect_to accounts_url, notice: "Account transactions updated"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:name, :bank, :country)
    end
end
