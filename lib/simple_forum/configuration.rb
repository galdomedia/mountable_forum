module SimpleForum
  module Configuration
    mattr_accessor :implementations
    @@implementations = {}

    mattr_accessor :requirements
    @@requirements = []

    def self.requires(*args)
      args.each do |required_api|
        raise ArgumentError, 'You must define a requirement with a symbol!' unless required_api.is_a?(Symbol)
        @@requirements.push required_api
      end
    end

    def self.implement(requirement, &blk)
      raise ArgumentError, 'You must define an implementation with a symbol!' unless requirement.is_a?(Symbol)
      @@implementations.merge!({requirement => blk})
      @@implementations[requirement]
    end

    def self.invoke(method, *args)
      raise ArgumentError, 'The requested implementation was not required!' unless @@requirements.include?(method)
      raise AbstractAuth::Errors::NotImplementedError.new('The requirement was not implemented!') unless @@implementations.has_key?(method)
      @@implementations[method]
    end

    class <<self
      def method_missing(symbol, *args, &block)
        self.class_eval <<-METHOD, __FILE__, __LINE__ + 1
            def self.#{symbol}(&block)                                      # def self.authenticated_user(&block)
              SimpleForum::Configuration.implement(:#{symbol}, &block)      #   implement(:authenticated_user, &block)
            end                                                             # end
        METHOD
        send(symbol, &block)
      end
    end
  end
end