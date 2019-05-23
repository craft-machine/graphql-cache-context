require 'graphql/cache_context/version'
require 'graphql/cache_context/store'

module GraphQL
  class CacheContext
    def use(schema_definition)
      schema_definition.instrument(:field, self)
    end

    def instrument(type, field)
      old_resolve_proc = field.resolve_proc

      new_resolve_proc = ->(object, arguments, context) do

        # it means we want to get cache object
        arity = old_resolve_proc.respond_to?(:arity) ? old_resolve_proc.arity : old_resolve_proc.method(:call).arity
        if arity == 4
          cache = GraphQL::CacheContext::Store.new(context)
          old_resolve_proc.call(object, arguments, context, cache)
        else
          old_resolve_proc.call(object, arguments, context)
        end
      end

      field.redefine { resolve(new_resolve_proc) }
    end
  end
end
