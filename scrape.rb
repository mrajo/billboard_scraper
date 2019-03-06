require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/Billboard_Year-End_Hot_100_singles_of_1991'))

doc.search('.wikitable tbody tr').each do |row|
  num = row.search('th').text.strip
  title = row.search('td:first a').text.strip
  artist = row.search('td:last a').text.strip

  puts "#{num}: #{artist} - #{title}"
end
