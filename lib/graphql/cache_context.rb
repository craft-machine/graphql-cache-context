require 'graphql/cache_context/version'
require 'graphql/cache_context/store'

module GraphQL
  class CacheContext
    DEFAULT_ARITY_FOR_GRAPHQL = 3
    ARITY_FOR_GRAPHQL_WITH_CACHE = 4

    def use(schema_definition)
      schema_definition.instrument(:field, self)
    end

    def instrument(type, field)
      old_resolve_proc = field.resolve_proc

      new_resolve_proc = ->(object, arguments, context) do
        # it means we want to get cache object
        if method_arity(old_resolve_proc) == ARITY_FOR_GRAPHQL_WITH_CACHE
          cache = GraphQL::CacheContext::Store.new(context)
          old_resolve_proc.call(object, arguments, context, cache)
        else
          old_resolve_proc.call(object, arguments, context)
        end
      end

      field.redefine { resolve(new_resolve_proc) }
    end

    private

    def method_arity(field_resolve)
      return field_resolve.arity if field_resolve.respond_to?(:arity)
      return field_resolve.method(:call).arity if field_resolve.respond_to?(:call)

      DEFAULT_ARITY_FOR_GRAPHQL
    end
  end
end
