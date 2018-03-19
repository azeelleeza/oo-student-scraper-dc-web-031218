require 'open-uri'
require 'pry'
require "nokogiri"

class Scraper
@@scraped_students = []
attr_accessor :scraped_student


  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index_page = Nokogiri::HTML(html)

     index_page.css("div.student-card").each do |student|
      @@scraped_students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end
    @@scraped_students

  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile_page = Nokogiri::HTML(html)

    profile_page.css("body").each do |element|
      @scraped_student = {}
      @scraped_student[:profile_quote] = element.css(".profile-quote").text
      @scraped_student[:bio] = element.css(".bio-block p").text

      element.css(".social-icon-container a").each do |website|
        @scraped_student[:twitter] = website.attribute("href").text if website.css("img").attribute("src").value.split(/\/|\.|-/).include?("twitter")

        @scraped_student[:linkedin] = website.attribute("href").text if website.css("img").attribute("src").value.split(/\/|\.|-/).include?("linkedin")

        @scraped_student[:github] = website.attribute("href").text if website.css("img").attribute("src").value.split(/\/|\.|-/).include?("github")

        @scraped_student[:blog] = website.attribute("href").text if website.css("img").attribute("src").value.split(/\/|\.|-/).include?("rss")
      end

    end
    @scraped_student
  end

scrape_profile_page("./fixtures/student-site/students/joe-burgess.html")

end
