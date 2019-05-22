module GraphQL
  class CacheContext::Store
    attr_reader :context

    def initialize(context)
      @context = context
    end

    def fetch(key)
      context[:cache] ||= {}
      context[:cache][key] ||= yield if block_given?
      context[:cache][key]
    end
  end
end
