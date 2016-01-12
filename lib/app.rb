require 'json'
require 'date'
require 'artii'
$artii = Artii::Base.new
def setup
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  products_hash = JSON.parse(file)
end

# Print "Sales Report" in ascii art
def print_in_ascii(text)
  puts $artii.asciify(text)
end

def print_heading
  puts
end

def create_report
  print_heading('salesreport')
  # print_data
end

def start
  products_hash = setup
  create_report(products_hash)
end
puts "\nSales Report"
puts Date.today

puts '                     _            _       '
puts '                    | |          | |      '
puts ' _ __  _ __ ___   __| |_   _  ___| |_ ___ '
puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
puts '| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\'
puts '| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/'
puts '| |                                       '
puts '|_|                                       '

# For each product in the data set:
products_hash['items'].each do |toy|
  # Print the name of the toy
  puts "\nName: #{toy['title']}"

  # Print the retail price of the toy
  puts "Retail price: #{toy['full-price']}$"

  # Calculate and print the total number of purchases
  puts "Total purchases: #{toy['purchases'].length}"

  # Calculate and print the total amount of sales
  total_sales = toy['purchases'].map { |purchase| purchase['price'] }.reduce(:+)
  puts "Revenue total: #{total_sales}$"

  # Calculate and print the average price the toy sold for
  average_price = total_sales / toy['purchases'].length
  puts "Average sale price: #{average_price}$"

  # Calculate and print the average discount (% or $) based off the average sales price
  average_discount_dollar = toy['full-price'].to_f - average_price.to_f
  average_discount_percent = (100 - average_price.to_f / toy['full-price'].to_f * 100.0)
  puts "Average discount: #{average_discount_dollar}$ = #{average_discount_percent.round(2)}%"
end

puts ' _                         _     '
puts '| |                       | |    '
puts '| |__  _ __ __ _ _ __   __| |___ '
puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
puts '| |_) | | | (_| | | | | (_| \\__ \\'
puts '|_.__/|_|  \\__,_|_| |_|\\__,_|___/'
puts

# For each brand in the data set:
# create a hash of all brands and toys {:Lego => [toy1, toy2], :nano => [toy3]}
brands = {}
products_hash['items'].each do |toy|
  if !brands.include?(toy['brand'].to_sym)
    # if brands does not contain the brand yet, add the brand as the key
    # and the toy in an array to the value
    brands[toy['brand'].to_sym] = [toy]

  else
    # else add toy to the value's array
    brands[toy['brand'].to_sym] << toy
  end
end

brands.each do |brand, products|
  # Print the name of the brand
  puts "\nName: #{brand}"

  # Count and print the number of the brand's toys we stock
  brand_stock = products.map { |product| product['stock'] }.reduce(:+)
  puts "Brand stock total: #{brand_stock}"
  puts "Brands different products #{products.length}"

  # Calculate and print the average price of the brand's toys
  brand_average_price = (products.map { |product| product['full-price'].to_f }.reduce(:+)) / products.length
  puts "Brand average price: #{brand_average_price.round(2)}$"

  # Calculate and print the total revenue of all the brand's toy sales combined
  brand_revenue = 0.0
  all_purchases_per_product = products.map { |product| product['purchases'] }
  all_purchases_per_product.each do |product|
    product.each do |sale|
      brand_revenue += sale['price']
    end
  end
  puts "Brand revenue: #{brand_revenue.round(2)}$"
end
