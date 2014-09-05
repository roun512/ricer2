# Threadcount statistics
module Ricer
  class Thread < Thread
    
    def self.bot; Ricer::Bot.instance; end

    @@mutex = Mutex.new

    @@peak = 1
    def self.peak; @@peak; end
    def self.count; list.length; end

    @@thread_guid = 2
      
    def initialize
      super
      now = Thread.list.length
      @@peak = now if now > @@peak
    end
    
    ####################################
    ### Debug and Exception handling ###
    ####################################
    def self.execute(&proc)
      new do
        guid = 0
        @@mutex.synchronize do
          guid = @@thread_guid; @@thread_guid += 1;
        end
        begin
          bot.log_debug "[#{guid}] Started thread at #{display_proc(proc)}"
          yield proc
          bot.log_debug "[#{guid}] Stopped thread at #{display_proc(proc)}"
#       rescue ActiveRecord::NoDatabaseError => e
#          bot.running = false
        rescue Exception => e
          bot.log_exception(e)
          bot.log_debug "[#{guid}] Killed thread at #{display_proc(proc)}"
        end
      end
    end

    def self.display_proc(proc)
      sl = proc.source_location or raise StandardError("No source location for proc")
      "#{sl[0]} #{sl[1]}"
    end

  end
end
