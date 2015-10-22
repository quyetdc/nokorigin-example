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
    browser = Watir::Browser.start "http://lexin.nada.kth.se/lexin/#searchinfo=both,swe_swe,#{params[:search]};"
    
    doc = Nokogiri::HTML.parse(browser.html)
    doc.search('img[src="img/tree_white.gif"]').each do |src|
      src.remove
    end

    doc.search('img[src="img/tree_open.gif"]').each do |src|
      src.remove
    end
    
    @word_meaning = doc.at('.lexingwt-TranslationPanel').to_s

    browser = Watir::Browser.start "http://www.google.com/search?tbm=isch&q=#{params[:search]}"    
    doc = Nokogiri::HTML.parse(browser.html)

    # binding.pry
    @img_links = []
    # binding.pry

    doc.css('img.rg_i').first(5).each do |noko|
      @img_links << noko.attributes['src'].value
    end
    
    respond_to do |format|      
      format.json { render json: { word_meaning: @word_meaning, img_links: @img_links }} 
    end
  end

end
