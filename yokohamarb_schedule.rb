# coding: utf-8
require 'rubygems'
require 'bundler/setup'

require 'nokogiri'
require 'open-uri'

class YokohamaSchedule
  def initialize(month=0)
    @month = month if month
    @yokohama_rb_uri = 'http://bukt.org/groups/3'
    @schedule_xpath = '//div[@class="groups"]/div[@class="events"]/table/tr'
    @date = 'td[2]'
    @time = 'td[3]'
    @title = 'td[@class="bold"]'
    @capacity = 'td[5]'
    @plans = []
    @plan = {
      date: '', 
      time: '', 
      title: '', 
      capacity: '', 
    }
  end

  def scrape
    @doc = Nokogiri::HTML(open(@yokohama_rb_uri))

    @doc.search(@schedule_xpath).each do |tr|
      @plan[:date] = tr.search(@date).inner_text
      @plan[:time] = tr.search(@time).inner_text
      @plan[:title] = tr.search(@title).inner_text
      @plan[:capacity] = tr.search(@capacity).inner_text.gsub(/\n/, '')

      @plans << @plan.dup
      @plan.clear
    end
  end

  def show_all_plan
    @plans.each do |plan|
      print_plan(plan)
    end
  end

  def show_plan
    if @month
      show_near_plan
    else
      show_all_plan
    end
  end

  def show_near_plan
    @plans.each do |plan|
      if plan[:date][/(\d+)/].eql? @month.to_s
        puts "#{@month}月の開催情報\n"
        print_plan(plan)
      end
    end
  end

  def print_plan(plan)
    puts "開催日     #{plan[:date]}"
    puts "開始時間   #{plan[:time]}"
    puts "イベント名 #{plan[:title]}"
    puts "人数       #{plan[:capacity]}\n\n"
  end
end

month = ARGV.first
schedule = YokohamaSchedule.new(month)
schedule.scrape
schedule.show_plan

