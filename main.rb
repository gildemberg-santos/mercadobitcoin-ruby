require 'date'
require 'yaml'
require_relative 'src/api'

@trading = Api.new
@configurations = YAML.load_file('config.yml')

def analyze
  ticker = @trading.getTicker

  last_purchase_order = @configurations['last_purchase_order'].to_f
  last_purchase_price = ticker[:last].to_f
  purchase_margin = last_purchase_order - (last_purchase_order * @configurations['percentage'].to_f)
  sale_margin = last_purchase_order + (last_purchase_order * @configurations['percentage'].to_f)
  price_margin = (last_purchase_order / (last_purchase_price * 100)) * -1

  puts "Último preço de compra: #{last_purchase_price}"
  puts "Último pedido de compra: #{last_purchase_order}"
  puts "Margem de compra: #{purchase_margin}"
  puts "Margem de vendas: #{sale_margin}"
  puts "Margem de preço : #{price_margin}"

  if (last_purchase_price < last_purchase_order) && (last_purchase_price <= purchase_margin)
    puts 'COMPRAR'
  elsif (last_purchase_price > last_purchase_order) && (last_purchase_price >= sale_margin)
    puts 'VENDER'
  end
end

loop do
  system(:clear.to_s)
  analyze
  sleep(@configurations['interval'].to_i)
end
