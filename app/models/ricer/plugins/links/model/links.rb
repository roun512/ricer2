module Ricer::Plugins::Links::Model
  class Links < ActiveRecord::Base

        belongs_to :user, :class_name => 'Ricer::Irc::User'
        belongs_to :channel, :class_name => 'Ricer::Irc::Channel'

        def self.upgrade_1
            m = ActiveRecord::Migration
            m.create_table table_name do |t|
                t.integer   :user_id,    :null => false
                t.integer   :channel_id, :null => true
                t.text      :link,    :null => false
                t.text      :title, :null => true
                t.text      :category, :null => false
                t.timestamp :created_at
        end
    end
  end
end
