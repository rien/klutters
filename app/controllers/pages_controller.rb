
class PagesController < ApplicationController
  def home
    @accounts = Account.all
    @transactions = Transaction.all.limit(10)
  end
end
