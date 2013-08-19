require 'rubygems'
require 'bundler'
begin
  Bundler.require(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Schema.verbose = false

def setup_db
  ActiveRecord::Schema.define(version: 1) do
    create_table :names do |t|
      t.column :name, :string
      t.column :expires_at, :datetime
    end

    create_table :tokens do |t|
      t.column :token, :string
      t.column :good_until, :datetime
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Name < ActiveRecord::Base
  def self.table_name
    "names"
  end
end

class ExpirableName < Name
  acts_as_expirable
end

class ExpirableNameDefault < Name
  acts_as_expirable default: "2014-02-03 09:00:45 UTC"
end

class Token < ActiveRecord::Base
  acts_as_expirable column: :good_until, default: ->(r) { Time.now + 1.day }
end