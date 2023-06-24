class QuotesController < ApplicationController
  before_action :set_quote, only: %i[show edit update destroy]

  def index
    @quotes = current_company.quotes.ordered # works with scope property in quote model
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = current_company.quotes.build(quote_params)
    respond_to do |format|
      if @quote.save
        format.html do
          redirect_to quotes_path, notice: "Quote was successfully created."
        end
        format.turbo_stream do
          flash.now[:notice] = "Quote was successfully created."
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html do
          redirect_to quotes_path, notice: "Quote was successfully updated."
        end
        format.turbo_stream do
          flash.now[:notice] = "Quote was successfully updated"
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quote.destroy
    respond_to do |format|
      format.html do
        redirect_to quotes_path, notice: "Quote was successfully destroyed."
      end
      format.turbo_stream do
        flash.now[:notice] = "Quote was successfully destroyed."
      end
    end
  end

  private

  def set_quote
    # We must use current_company.quotes here instead of Quote
    # for security reasons
    @quote = current_company.quotes.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:name)
  end
end
