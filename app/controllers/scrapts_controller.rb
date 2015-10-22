require 'nokogiri'
require 'open-uri'
require 'watir'
require "selenium-webdriver"

class ScraptsController < ApplicationController
  def home
  end

  # POST /search
  def search
    Selenium::WebDriver::PhantomJS.path = Rails.root.join('bin', 'phantomjs').to_s

    browser = Watir::Browser.start "http://lexin.nada.kth.se/lexin/#searchinfo=both,swe_swe,#{params[:search]};", :phantomjs

    dic = Nokogiri::HTML(browser.table(:class, 'lexingwt-TranslationPanel').html)

    dic.search('img[src="img/tree_white.gif"]').each do |src|
      src.remove
    end

    # binding.pry

    dic.search('img[src="img/tree_open.gif"]').each do |src|
      src.remove
    end

    @word_meaning = dic.to_s

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
