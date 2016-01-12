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
  $report_file.write "\n#{$artii.asciify(text)}"
end

def print_heading
  print_in_ascii('salesreport')
  $report_file.write "\n#{Date.today}"
end

def print_toy_name(toy)
  # Print the name of the toy
  $report_file.write "\n\nName: #{toy['title']}"
end

def print_toy_price(toy)
  # Print the retail price of the toy
  $report_file.write "\nRetail price: #{toy['full-price']}$"
end

def print_toy_total_purchases(toy)
  # Calculate and print the total number of purchases
  $report_file.write "\nTotal purchases: #{toy['purchases'].length}"
end

def calculate_toy_total_sales(toy)
  toy['purchases'].map { |purchase| purchase['price'] }.reduce(:+)
end

def print_toy_revenue(toy)
  # Calculate and print the total amount of sales
  $report_file.write "\nRevenue total: #{calculate_toy_total_sales(toy)}$"
end

def calculate_toy_average_price(toy)
  # Calculate  the average price the toy sold for
  calculate_toy_total_sales(toy) / toy['purchases'].length
end

def print_toy_average_price(toy)
  # Print the average price the toy sold for
  $report_file.write "\nAverage sale price: "
  $report_file.write "#{calculate_toy_average_price(toy)}$"
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
  $report_file.write "\nAverage discount: "
  $report_file.write "#{calculate_toy_average_discount_dollar(toy)}$ = "
  $report_file.write "#{calculate_toy_average_discount_percent(toy).round(2)}%"
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
  $report_file.write "\n\nName: #{brand}"
end

def calulate_brand_stock(products)
  # Count the number of the brand's toys we stock
  products.map { |product| product['stock'] }.reduce(:+)
end

def print_brand_stock(products)
  # Print the number of the brand's toys we stock
  $report_file.write "\nBrand stock total: #{calulate_brand_stock(products)}"
  $report_file.write "\nBrands different products #{products.length}"
end

def calculate_brand_average_price(products)
  # Calculate the average price of the brand's toys
  (products.map { |product| product['full-price'].to_f }.reduce(:+)) / products.length
end

def print_brand_average_price(products)
  # Print the average price of the brand's toys
  $report_file.write "\nBrand average price:"
  $report_file.write " #{calculate_brand_average_price(products).round(2)}$"
end

def calculate_brand_revenue(products)
  # Calculate the total revenue of all the brand's toy sales combined
  brand_revenue = 0.0
  all_purchases_per_product = products.map { |product| product['purchases'] }
  all_purchases_per_product.each do |product|
    product.each do |sale|
      brand_revenue += sale['price']
    end
  end
  brand_revenue
end

def print_brand_revenue(products)
  # Print the total revenue of all the brand's toy sales combined
  $report_file.write "\nBrand revenue: #{calculate_brand_revenue(products).round(2)}$"
end

def print_brands
  print_in_ascii('brands')
  brands = create_brands_hash($products_hash)
  brands.each do |brand, products|
    print_brand_name(brand)
    print_brand_stock(products)
    print_brand_average_price(products)
    print_brand_revenue(products)
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
