require 'csv'

class PagesController < ApplicationController
  def index
  end

  def upload
    if params.has_key?(:purchases)
      uploaded_io = params[:purchases]
      file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)

      Parser.process(uploaded_io, file_path)

      purchase_details = CSV.read(file_path, {:headers => :first_row, :col_sep => "\t" })

      # add data
      purchase_details.each do |row|
        customer_name = row['purchaser name']
        item_description = row['item description']
        item_price = row['item price']
        purchase_count = row['purchase count']
        merchant_name = row['merchant name']
        merchant_address = row['merchant address']

        merchant = Merchant.find_or_create_by_name_and_address!(name:merchant_name, address:merchant_address)
        item = merchant.items.find_or_create_by_description!(description:item_description, price:item_price)
        customer = Customer.find_or_create_by_name!(name:customer_name)

        Purchase.create(count:purchase_count).tap do |purchase|
          purchase.customer_id = customer.id
          purchase.item_id = item.id
          purchase.save!
        end
      end

      total = purchase_details.map { |row| row['item price'].to_i * row['purchase count'].to_i }.sum

      flash[:notice] = "file uploaded. total revenue = $#{total}"
    else
      flash[:notice] = 'please select a file'
    end

    render :index
  end
end
