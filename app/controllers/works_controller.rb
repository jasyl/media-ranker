class WorksController < ApplicationController

  before_action :find_work, only: [:show, :edit, :update, :destroy]
  def index
    @works = Work.order("votes_count DESC, created_at")
  end

  def show
    if @work.nil?
      render file: "#{Rails.root}/public/404.html",  layout: false, status: :not_found
      return
    end

  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)
    if @work.save
      redirect_to work_path(@work), success: "Successfully created #{@work.category} #{@work.id}"
      return
    else
      flash.now[:error] = ["A problem occurred: Could not create #{@work.category}"]
      flash.now[:error] << @work.format_errors
      render :new, status: :bad_request
      return
    end
  end

  def edit
    if @work.nil?
      render file: "#{Rails.root}/public/404.html",  layout: false, status: :not_found
      return
    end
  end

  def update
    if @work.nil?
      render file: "#{Rails.root}/public/404.html",  layout: false, status: :not_found
      return
    elsif @work.update(work_params)
      redirect_to work_path(@work), success: "Successfully updated #{@work.category} #{@work.id}"
      return
    else # update failed
      flash.now[:error] = ["A problem occurred: Could not update #{@work.category}"]
      flash.now[:error] << @work.format_errors
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    if @work.nil?
      render file: "#{Rails.root}/public/404.html",  layout: false, status: :not_found
      return
    elsif @work.delete
      @work.votes.each {|vote| vote.delete}
      redirect_to works_path, success: "Successfully deleted #{@work.category} #{@work.id}"
      return
    end
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def find_work
    @work = Work.find_by(id: params[:id])
  end
end
