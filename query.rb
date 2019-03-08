#!/usr/bin/env ruby


require './db.rb'

db = BillboardDb.new
db.query ARGV[0]