module ActsAsExpirable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def acts_as_expirable(options = {})
      configuration = { :column => "expires_at" }
      configuration.update(options) if options.is_a?(Hash)

      class_eval %{
        include ActsAsExpirable::InstanceMethods

        def acts_as_list_class
          ::#{self.name}
        end

        def expiry_column
          '#{configuration[:column]}'
        end

        scope :expired, where('#{configuration[:column]} <= NOW()')
        scope :unexpired, where('#{configuration[:column]} > NOW()')
        scope :non_expired, where('#{configuration[:column]} is null')

        class << self
          def destroy_expired
            expired.destroy_all
          end

          def delete_expired
            expired.delete_all
          end
        end
      }
    end
  end

  module InstanceMethods
    def expire
      write_attribute(self.class.expiry_column, Time.now)
    end

    def expire!
      update_attribute(self.class.expiry_column, Time.now)
    end
  end
end
