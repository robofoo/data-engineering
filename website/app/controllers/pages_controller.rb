class PagesController < ApplicationController
  def index
  end

  def upload
    if params.has_key?(:purchases)
      uploaded_io = params[:purchases]
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
        file.write(uploaded_io.read)
      end

      flash[:notice] = 'file uploaded'
    else
      flash[:notice] = 'please select a file'
    end

    render :index
  end
end
