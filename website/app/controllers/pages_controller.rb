require 'csv'

class PagesController < ApplicationController
  def index
  end

  def upload
    if params.has_key?(:purchases)
      uploaded_io = params[:purchases]
      file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)

      total = Parser.process(uploaded_io, file_path)

      flash[:notice] = "file uploaded. total revenue = $#{total}"
    else
      flash[:notice] = 'please select a file'
    end

    render :index
  end
end
