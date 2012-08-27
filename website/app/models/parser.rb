module Parser
  extend self

  def process(uploaded_io, file_path)
    save_file(uploaded_io, file_path)
    store_purchase_data(file_path)
    total_purchases(file_path)
  end

  def save_file(uploaded_io, file_path)
    File.open(file_path, 'w') do |file|
      file.write(uploaded_io.read)
    end
  end

  def store_purchase_data(file_path)
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
  end

  def total_purchases(file_path)
    purchase_details = CSV.read(file_path, {:headers => :first_row, :col_sep => "\t" })
    purchase_details.map { |row| row['item price'].to_i * row['purchase count'].to_i }.sum
  end
end
