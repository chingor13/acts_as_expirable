require 'acts_as_expirable/expirable'
ActiveRecord::Base.send(:include, ActsAsExpirable)
