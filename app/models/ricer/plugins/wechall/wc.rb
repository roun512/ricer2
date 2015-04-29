require 'open-uri'
module Ricer::Plugins::Wechall
	class Wc < Ricer::Plugin

    trigger_is :wc

    has_usage :execute and has_usage :execute_msg, '<..message..>'
		
	  def execute_msg(msg)
		  if msg === ''
			  msg = sender.name
		  end
		  reply open("http://www.wechall.net/wechall.php?username=#{URI::encode(msg)}").read()
    end

    def execute
      msg = sender.name
      reply open("http://www.wechall.net/wechall.php?username=#{URI::encode(msg)}").read()
    end
  end
end
