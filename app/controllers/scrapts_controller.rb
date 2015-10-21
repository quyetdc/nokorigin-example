require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'watir'

class ScraptsController < ApplicationController
  def home
  end

  # POST /search
  def search
    # binding.pry

    browser = Watir::Browser.new
    browser.goto 'http://lexin.nada.kth.se/lexin/#searchinfo=both,swe_swe,hittar;'

    doc = Nokogiri::HTML.parse(browser.html)
    @word_meaning = doc.at('.lexingwt-TranslationPanel')

    respond_to do |format|
      format.js
    end
  end

end
