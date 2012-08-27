class PagesController < ApplicationController
  def index
  end

  def upload
    if params.has_key?(:purchases)
      flash[:notice] = 'file uploaded'
    else
      flash[:notice] = 'please select a file'
    end

    render :index
  end
end
