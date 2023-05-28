# frozen_string_literal: true

class HomepageController < ApplicationController
  def index;
      require 'net/http'
      require "uri"

      uri = URI('http://empfehl-flask:8000/recommend')

      response = Net::HTTP.get(uri)
      @empfehlung = response

  end
  # static pages
  def about; end

  def impressum; end

  def contact; end

  def privacy; end

  def faq; end
end
