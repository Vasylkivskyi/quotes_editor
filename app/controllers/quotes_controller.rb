class QuotesController < ApplicationController
  before_action :set_quote, only: %i[show edit update destroy]

  @@create_notice = "Quote was successfully created!"
  @@edit_notice = "Quote was successfully edited!"
  @@delete_notice = "Quote was successfully deleted!"

  def index
    @quotes = current_company.quotes.ordered # works with scope property in quote model
  end

  def show
    @line_item_dates = @quote.line_item_dates.includes(:line_items).ordered
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = current_company.quotes.build(quote_params)
    respond_to do |format|
      if @quote.save
        format.html { redirect_to quotes_path, notice: @@create_notice }
        format.turbo_stream { flash.now[:notice] = @@create_notice }
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
        format.html { redirect_to quotes_path, notice: @@edit_notice }
        format.turbo_stream { flash.now[:notice] = @@edit_notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_path, notice: @@delete_notice }
      format.turbo_stream { flash.now[:notice] = @@delete_notice }
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
