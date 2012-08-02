# coding: utf-8
require 'rubygems'
require 'bundler/setup'

require 'nokogiri'
require 'open-uri'

plans = []

def plans.print_schedule
  self.each do |plan|
    puts "開催日     #{plan[:date]}\n"
    puts "開始時間   #{plan[:time]}\n"
    puts "イベント名 #{plan[:title]}\n"
    puts "人数       #{plan[:date]}\n\n"
  end
end

plan = {
  date: '',
  time: '',
  title: '',
  capacity: '',
}

doc = Nokogiri::HTML(open('http://bukt.org/groups/3'))

doc.search('//div[@class="groups"]/div[@class="events"]/table/tr').each do |tr|
  plan[:date]     = tr.search('td[2]').inner_text
  plan[:time]     = tr.search('td[3]').inner_text
  plan[:title]    = tr.search('td[@class="bold"]').inner_text
  plan[:capacity] = tr.search('td[5]').inner_text

  plans << plan.dup
  plan.clear
end

plans.print_schedule

