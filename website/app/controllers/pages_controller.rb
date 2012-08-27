require 'csv'

class PagesController < ApplicationController
  def index
  end

  def upload
    if params.has_key?(:purchases)
      uploaded_io = params[:purchases]
      file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
      File.open(file_path, 'w') do |file|
        file.write(uploaded_io.read)
      end

      purchase_details = CSV.read(file_path, {:headers => :first_row, :col_sep => "\t" })

      total = purchase_details.map { |row| row['item price'].to_i * row['purchase count'].to_i }.sum

      flash[:notice] = "file uploaded. total revenue = $#{total}"
    else
      flash[:notice] = 'please select a file'
    end

    render :index
  end
end
