require 'open-uri'
module Ricer::Plugins::Wechall
	class Wcc < Ricer::Plugin

    trigger_is :wcc

    has_usage :execute and has_usage :execute_msg, '<..message..>'
		
		def execute_msg(msg)
			if msg === ''
				msg = sender.name
			end
		  reply open("http://www.wechall.net/wechallchalls.php?username=#{URI::encode(msg)}").read()
    end

    def execute
     	msg = sender.name
     	reply open("http://www.wechall.net/wechallchalls.php?username=#{URI::encode(msg)}").read()
    end
  end
end
