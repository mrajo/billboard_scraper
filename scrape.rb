#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require './db.rb'

ROOT_URL = 'https://en.wikipedia.org'
START_PATH = '/wiki/Billboard_year-end_top_30_singles_of_1950'

toc = Nokogiri::HTML(open("#{ROOT_URL}#{START_PATH}"))
db = BillboardDb.new

# get links to all year-end lists
toc.search('//div[@aria-labelledby="Billboard_Year-End_Hot_100_singles"]//td//ul//li//a').each do |yearLink|
  year = yearLink.text.strip

  if !yearLink['href']
    doc = toc
  else
    path = yearLink['href'].strip
    doc = Nokogiri::HTML(open("#{ROOT_URL}#{path}"))
  end

  # table formats change in 1982
  if (year.to_i < 1982)
    doc.search('//table[contains(@class, "wikitable")]//tr[not(th)]').each do |row|
      rank = row.search('.//td[1] | .//th[1]').text.strip
      song = row.search('.//td[2]//a').text.strip
      artist = row.search('.//td[3]//a').text.strip
      db.addSong year, rank, song, artist
      puts "Added song [#{year}] (#{rank}) #{artist} - #{song}"
    end
  else
    doc.search('//table[contains(@class, "wikitable")]//tr[th[not(@scope="col")]]').each do |row|
      rank = row.search('th').text.strip
      song = row.search('td:first a').text.strip
      artist = row.search('td:last a').text.strip
      db.addSong year, rank, song, artist
      puts "Added song [#{year}] (#{rank}) #{artist} - #{song}"
    end
  end
end
