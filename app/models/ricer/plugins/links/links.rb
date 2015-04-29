require 'nokogiri'
require 'open-uri'

module Ricer::Plugins::Links
  class Links < Ricer::Plugin

    scope_is :channel

    def upgrade_1
     Ricer::Plugins::Links::Model::Links.upgrade_1
    end

    def on_privmsg
      words = privmsg_line
      if words.include?('http://') || words.include?('https://')
        words = words.split(" ")
        words.each do |link|
          if link.include?('http://') || link.include?('https://')
            Ricer::Thread.execute do
              url = open(link)
              doc = Nokogiri::HTML(url, nil, 'UTF-8')
              title = ''
              category = ''
              if doc.at_css('title')
                title = doc.css('title').text
                category = 'website'
              end
              if url.content_type.start_with?("image")
                open(link) {|img|
                  File.open("files/images/#{Time.now.strftime("%Y-%d-%m_%S")}.png", 'wb') do |image|
                    image.write img.read
                  end
                }
                category = 'mime'
              end
              if url.content_type.start_with?("video")
                category = "video"
              end
              if url.content_type.start_with?("audio")
                category = "audio"
              end
              Ricer::Plugins::Links::Model::Links.create!({
                user: user,
                channel: channel,
                link: link,
                title: title,
                category: category
              })
            bot.log_debug "Link has been added!"
            end
          end
        end
      end
    end
  end
end
