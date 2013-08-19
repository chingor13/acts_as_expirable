require 'active_record'
require 'active_support/concern'
require 'acts_as_expirable/expirable'
ActiveRecord::Base.send(:include, ActsAsExpirable)
