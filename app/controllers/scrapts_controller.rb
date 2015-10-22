require 'nokogiri'
require 'open-uri'
require 'watir'
require 'headless'

class ScraptsController < ApplicationController
  def home
  end

  # POST /search
  def search
    # binding.pry
    headless = Headless.new
    headless.start
    browser = Watir::Browser.start 'http://lexin.nada.kth.se/lexin/#searchinfo=both,swe_swe,hittar;'
    
    doc = Nokogiri::HTML.parse(browser.html)
    @word_meaning = doc.at('.lexingwt-TranslationPanel').to_s

    respond_to do |format|      
      format.json { render json: { word_meaning: @word_meaning }} 
    end
  end

end
