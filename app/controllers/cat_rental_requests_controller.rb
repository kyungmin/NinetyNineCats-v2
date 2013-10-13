class CatRentalRequestsController < ApplicationController
  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(params[:cat_rental_request])
    if @cat_rental_request.save
      @cat = Cat.find_by_id(@cat_rental_request.cat_id)
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def approve
    current_request.approve!
    redirect_to cat_url(current_cat)
  end

  def deny
    current_request.deny!
    redirect_to cat_url(current_cat)
  end

  private

  def current_request
    @cat_rental_request ||= CatRentalRequest.find_by_id(params[:id])
  end

  def current_cat
    @cat ||= current_request.cat
  end
end
