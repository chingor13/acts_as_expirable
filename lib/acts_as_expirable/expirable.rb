module ActsAsExpirable
  def self.included(base)
    base.extend(ClassMethods)
  end

  def self.cleanup!
    expirable_classes.each do |klass|
      klass.unscoped.destroy_expired
    end
  end

  def self.expirable_classes
    @expirable_classes ||= []
  end

  def self.register_expirable(klass)
    @expirable_classes ||= []
    @expirable_classes << klass
  end

  module ClassMethods
    def acts_as_expirable(options = {})
      ActsAsExpirable.register_expirable(self)

      configuration = { :column => "expires_at" }
      configuration.update(options) if options.is_a?(Hash)

      class_eval %{
        include ActsAsExpirable::InstanceMethods

        scope :expired, where('#{configuration[:column]} <= UTC_TIMESTAMP()')
        scope :unexpired, where('#{configuration[:column]} IS NULL OR #{configuration[:column]} > UTC_TIMESTAMP()')

        class << self
          def expiry_column
            '#{configuration[:column]}'
          end

          def destroy_expired
            expired.destroy_all
          end

          def delete_expired
            expired.delete_all
          end

          def default_scope
            unexpired
          end
        end
      }

      case configuration[:default]
      when Proc
        before_validation configuration[:default], :on => :create do
          write_attribute(configuration[:column], configuration[:default].call(self)) if read_attribute(configuration[:column]).nil?
          true
        end
      when NilClass
      else
        before_validation :on => :create do
          write_attribute(configuration[:column], configuration[:default]) if read_attribute(configuration[:column]).nil?
          true
        end
      end
    end
  end

  module InstanceMethods
    def expire
      write_attribute(self.class.expiry_column, Time.now)
    end

    def expire!
      update_attribute(self.class.expiry_column, Time.now)
    end

    def expired?
      expire_time = read_attribute(self.class.expiry_column)
      return false if expire_time.nil?
      expire_time <= Time.now
    end
  end
end
