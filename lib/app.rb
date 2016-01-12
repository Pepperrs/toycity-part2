require 'json'
require 'date'
require 'artii'
$artii = Artii::Base.new
def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new('report.txt', 'w+')
end

# Print "Sales Report" in ascii art
def print_in_ascii(text = 'text')
  puts $artii.asciify(text)
end

def print_heading
  print_in_ascii('salesreport')
  puts Date.today
end

def print_toy_name(toy)
  # Print the name of the toy
  puts "\nName: #{toy['title']}"
end

def print_toy_price(toy)
  # Print the retail price of the toy
  puts "Retail price: #{toy['full-price']}$"
end

def print_toy_total_purchases(toy)
  # Calculate and print the total number of purchases
  puts "Total purchases: #{toy['purchases'].length}"
end

def calculate_toy_total_sales(toy)
  toy['purchases'].map { |purchase| purchase['price'] }.reduce(:+)
end

def print_toy_revenue(toy)
  # Calculate and print the total amount of sales
  puts "Revenue total: #{calculate_toy_total_sales(toy)}$"
end

def calculate_toy_average_price(toy)
  # Calculate  the average price the toy sold for
  calculate_toy_total_sales(toy) / toy['purchases'].length
end

def print_toy_average_price(toy)
  # Print the average price the toy sold for
  puts "Average sale price: #{calculate_toy_average_price(toy)}$"
end

def calculate_toy_average_discount_dollar(toy)
  # Calculate the average discount ($) based off the average sales price
  toy['full-price'].to_f - calculate_toy_average_price(toy).to_f
end

def calculate_toy_average_discount_percent(toy)
  # Calculate the average discount ($) based off the average sales price
  (100 - calculate_toy_average_price(toy).to_f / toy['full-price'].to_f * 100.0)
end

def print_toy_average_discount(toy)
  # Print the average discount (% or $) based off the average sales price
  print "Average discount: #{calculate_toy_average_discount_dollar(toy)}$ = "
  puts "#{calculate_toy_average_discount_percent(toy).round(2)}%"
end

def print_products
  print_in_ascii('products')

  # For each product in the data set:
  $products_hash['items'].each do |toy|
    print_toy_name(toy)
    print_toy_price(toy)
    print_toy_total_purchases(toy)
    print_toy_revenue(toy)
    print_toy_average_price(toy)
    print_toy_average_discount(toy)
  end
end

def create_brands_hash(hash)
  # For each brand in the data set:
  # create a hash of all brands and toys {:Lego => [toy1, toy2],:nano => [toy3]}
  brands = {}
  hash['items'].each do |toy|
    if !brands.include?(toy['brand'].to_sym)
      # if brands does not contain the brand yet, add the brand as the key
      # and the toy in an array to the value
      brands[toy['brand'].to_sym] = [toy]

    else
      # else add toy to the value's array
      brands[toy['brand'].to_sym] << toy
    end
  end
  brands
end

def print_brand_name(brand)
  # Print the name of the brand
  puts "\nName: #{brand}"
end

def calulate_brand_stock(products)
  # Count the number of the brand's toys we stock
  products.map { |product| product['stock'] }.reduce(:+)
end

def print_brand_stock(products)
  # Print the number of the brand's toys we stock
  puts "Brand stock total: #{calulate_brand_stock(products)}"
  puts "Brands different products #{products.length}"
end

def calculate_brand_average_price(products)
  # Calculate the average price of the brand's toys
  (products.map { |product| product['full-price'].to_f }.reduce(:+)) / products.length
end

def print_brand_average_price(products)
  # Print the average price of the brand's toys
  print 'Brand average price:'
  puts " #{calculate_brand_average_price(products).round(2)}$"
end

def print_brands
  print_in_ascii('brands')
  brands = create_brands_hash($products_hash)
  brands.each do |brand, products|
    print_brand_name(brand)
    print_brand_stock(products)
    print_brand_average_price(products)

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
end

def create_report
  print_heading
  print_products
  print_brands
end

def start
  setup_files
  create_report
end

start
