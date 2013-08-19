module ActsAsExpirable
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_expirable(options = {})
      include Expirable
      self.acts_as_expirable_configuration = options.reverse_merge({
        column: "expires_at"
      })
    end
  end

  module Expirable
    extend ActiveSupport::Concern

    included do
      ActsAsExpirable.register_expirable(self)
      class_attribute :acts_as_expirable_configuration
      scope :expired, -> { where('#{acts_as_expirable_configuration[:column]} <= UTC_TIMESTAMP()') }
      scope :unexpired, -> { where('#{acts_as_expirable_configuration[:column]} IS NULL OR #{acts_as_expirable_configuration[:column]} > UTC_TIMESTAMP()') }
      delegate :expiry_column, to: :class
      before_validation :set_expiry_default, on: :create
    end

    module ClassMethods
      def expiry_column
        acts_as_expirable_configuration[:column]
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

    protected

    def set_expiry_default
      default = acts_as_expirable_configuration[:default]
      return true if default.nil?

      # set the value if the current value is not set
      if read_attribute(acts_as_expirable_configuration[:column]).nil?
        write_attribute(acts_as_expirable_configuration[:column],
          default.respond_to?(:call) ? default.call(self) : default
        )
      end
      true
    end
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

end
