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
    # headless = Headless.new
    # headless.start
    browser = (Watir::Browser.new :phantomjs).start "http://lexin.nada.kth.se/lexin/#searchinfo=both,swe_swe,#{params[:search]};"
    
    dic = Nokogiri::HTML.parse(browser)
    # binding.pry

    dic.search('img[src="img/tree_white.gif"]').each do |src|
      src.remove
    end
    #
    dic.search('img[src="img/tree_open.gif"]').each do |src|
      src.remove
    end

    @word_meaning = dic.at('.lexingwt-TranslationPanel').to_s

    # browser = Watir::Browser.start "http://www.google.com/search?tbm=isch&q=#{params[:search]}"
    doc = Nokogiri::HTML.parse(open("https://www.google.com/search?q=#{params[:search]}&tbm=isch"))

    @img_links = []

    doc.css('img').first(5).each do |noko|
      @img_links << noko.attributes['src'].value
    end
    
    respond_to do |format|      
      format.json { render json: { word_meaning: @word_meaning, img_links: @img_links }} 
    end
  end

end
