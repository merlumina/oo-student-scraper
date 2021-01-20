require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_html = Nokogiri::HTML(open(index_url))
    students = []
    index_html.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_name = student.css(".student-name").text
        student_location = student.css(".student-location").text
        student_profile_url = "#{student.attr('href')}"
        students << {name: student_name, location: student_location, profile_url: student_profile_url}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_html = Nokogiri::HTML(open(profile_url))
    links = profile_html.css(".social-icon-container").children.css("a").map {|link| link.attribute('href').value}
    links.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] = profile_html.css(".profile-quote").text
    student[:bio] = profile_html.css(".description-holder p").text
    student
  end

end

