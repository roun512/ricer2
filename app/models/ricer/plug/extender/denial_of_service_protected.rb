###
### Allows to deny multiple threads of a plugin for a user (or other scope)
###
### Example:
### denial_of_service_protected scope: :bot
###
### Ensures the execution can only be done once per bot instance.
### You need to call "stopped_service" to allow it again. 
###
module Ricer::Plug::Extender::DenialOfServiceProtected
  
  OPTIONS = {
    scope: :user
  }
  
  def denial_of_service_protected(options={})
    
    merge_options(options, OPTIONS)
    
    throw Exception.new("#{klass.name} denial_of_service_protected scope is invalid: #{options[:scope]}") if Ricer::Irc::Scope.by_name(options[:scope]).nil?
    
    class_eval do |klass|

      # Set option scope      
      klass.register_class_variable(:@dos_protection_scope)
      klass.instance_variable_set(:@dos_protection_scope, options[:scope])

      # Set exec cache
      klass.register_class_variable(:@dos_protection_cache)
      klass.instance_variable_set(:@dos_protection_cache, {})

      # Call this when the thread is started!      
      def start_service
        byebug
        if service_running?
          raise Ricer::ExecutionException.new(tt('ricer.plug.extender.denial_of_service_protected.err_already_running'))  
        end
        denial_of_service_cache[service_issuer] = 1
      end
      
      # Call this when the thread is done!      
      def stopped_service
        byebug
        denial_of_service_cache.delete(service_issuer)
      end
      
      protected
      
      def service_issuer
        scope = denial_of_service_scope
        if scope == :user
          @message.prefix.substr_from('!').substr_from('@') rescue 'HAX0R'
        else
          send(denial_of_service_scope).name
        end
      end
      
      def denial_of_service_scope
        self.class.instance_variable_get(:@dos_protection_scope)
      end

      def denial_of_service_cache
        self.class.instance_variable_get(:@dos_protection_cache)
      end
      
      def service_running?
        denial_of_service_cache[service_issuer] != nil
      end
      
    end
  end
end