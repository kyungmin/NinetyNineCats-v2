class CatsController < ApplicationController
  before_filter :require_owner, only: [:edit, :update]

  def index
    @cats = Cat.includes(:owner).all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(params[:cat])
    @cat.user_id = current_user.id

    if @cat.save
      render :show
    else
      render :new
    end
  end

  def show
    @cat = current_cat
    render :show
  end

  def edit
    @cat = current_cat
    render :edit    
  end

  def update
    current_cat.update_attributes!(params[:cat])
    redirect_to cat_url(current_cat)
    #render :show
  end

  private

  def current_cat
    @current_cat ||= Cat.includes(:owner).find(params[:id])
  end

  def require_owner
    redirect_to cat_url(current_cat) unless current_user.is_owner?(current_cat)
  end
end
