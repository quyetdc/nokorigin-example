require 'nokogiri'
require 'open-uri'
require 'watir'
require "selenium-webdriver"
require 'addressable/uri'

class ScraptsController < ApplicationController
  def home
  end

  # POST /search
  def search
    Selenium::WebDriver::PhantomJS.path = Rails.root.join('bin', 'phantomjs').to_s

    # Normalize url when it contains non-ascii characters
    uri = Addressable::URI.parse("http://lexin.nada.kth.se/lexin/#searchinfo=both,swe_swe,#{params[:search]};")
    uri = uri.normalize


    browser = Watir::Browser.start uri.to_s, :phantomjs

    # binding.pry

    browser.table(:class, 'lexingwt-TranslationPanel').wait_until_present


    html_result = browser.table(:class, 'lexingwt-TranslationPanel').html

    dic = Nokogiri::HTML(html_result)


    dic.search('img[src="img/tree_white.gif"]').each do |src|
      src.remove
    end

    # binding.pry

    dic.search('img[src="img/tree_open.gif"]').each do |src|
      src.remove
    end

    @word_meaning = dic.to_s

    uri = Addressable::URI.parse("https://www.google.com/search?q=#{params[:search]}&tbm=isch")
    uri = uri.normalize

    doc = Nokogiri::HTML(open(uri))

    @img_links = []

    doc.css('img').first(5).each do |noko|
      @img_links << noko.attributes['src'].value
    end
    
    respond_to do |format|      
      format.json { render json: { word_meaning: @word_meaning, img_links: @img_links }} 
    end
  end

end
