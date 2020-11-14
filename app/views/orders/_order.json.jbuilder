json.extract! order, :id, :first_name, :last_name, :street_address, :apt_num, :city, :state, :zip_code, :email, :created_at, :updated_at
json.url order_url(order, format: :json)
