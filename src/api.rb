require 'yaml'
require 'uri'
require 'net/http'
require 'date'

class Api
  def initialize
    configurations = YAML.load_file('config.yml')
    @url_api = "#{configurations['urls']['api']}/#{configurations['moeda']}"
  end

  private def getUrl(url)
    params = {
      'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0'
    }
    uri = URI(url)
    uri.query = URI.encode_www_form(params)
    eval Net::HTTP.get(uri)
  end

  def getTicker
    url = "#{@url_api}/ticker/"
    resp = getUrl(url)
    resp[:ticker] unless resp.nil?
  end

  def getOrderbook
    url = "#{@url_api}/orderbook/"
    getUrl(url)
  end

  def getDaySummary(data = Date.today - 1)
    url = "#{@url_api}/day-summary/#{data.year.to_s}/#{data.month.to_s}/#{data.day.to_s}/"
    getUrl(url)
  end
end
