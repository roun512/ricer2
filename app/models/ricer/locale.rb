module Ricer
  class Locale < ActiveRecord::Base
    
    def self.valid?(iso)
      exists?(iso)
    end

    def self.exists?(iso)
      where(:iso => iso).count > 0
    end
    
    def self.by_iso(iso)
      find_by(:iso => iso)
    end
    
    def to_label
      I18n.t("ricer.locale.#{self.iso}")
    end

  end
end