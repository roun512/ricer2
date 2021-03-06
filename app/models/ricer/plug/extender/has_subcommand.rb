module Ricer::Plug::Extender::HasSubcommand
  def has_subcommand(*plugin_names)
    class_eval do |klass|
      
      klass.register_class_variable(:@subcommand_names)
      klass.register_instance_variable(:@subcommands)
      klass.register_instance_variable(:@subcommand_depth)
      klass.register_instance_variable(:@parent_command)
      commands = klass.instance_variable_define(:@subcommand_names, [])
      
      plugin_names.each do |plugin_name|
        # Append to subcommand names
        commands.push(plugin_name) unless commands.include?(plugin_name)
        def subcommand_names
          self.class.instance_variable_get(:@subcommand_names)
        end
      end
      
      def has_subcommands?
        true
      end

      # def is_subcommand?
        # subcommand_depth > 1
      # end

      def subcommands
        @subcommands
      end
      
      def add_subcommand(plugin)
        plugin.parent_command = self
        @subcommand_depth ||= 1 
        plugin.subcommand_depth = @subcommand_depth + 1
        @subcommands ||= []
        @subcommands.push(plugin) unless @subcommands.include?(@plugin)
        bot.log_info("Added subcommand to '#{self.short_class_name}': '#{plugin.short_class_name}'.")
        self
      end
      
    end
  end
end
