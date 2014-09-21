module Ricer::Plug::Params
  class EmailParam < StringParam

    def convert_in!(input, message)
      begin
        email = Mail::Address.new(input)
        failed_input unless (email.domain) && (email.address == input) && (email.__send__(:tree).domain.dot_atom_text.elements.length > 1)
      rescue => e
        failed_input
      end
      input
    end
    
    def convert_out!(email, message)
      email.to_s
    end
    
  end
end
