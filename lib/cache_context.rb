require 'cache_context/version'
require 'cache_context/store'

class CacheContext
  def use(schema_definition)
    schema_definition.instrument(:field, self)
  end

  def instrument(type, field)
    old_resolve_proc = field.resolve_proc

    new_resolve_proc = ->(object, arguments, context) do

      # it means we want to get cache object
      if old_resolve_proc.is_a?(Proc) && old_resolve_proc.arity == 4
        cache = CacheContext::Store.new(context)
        old_resolve_proc.call(object, arguments, context, cache)
      else
        old_resolve_proc.call(object, arguments, context)
      end
    end

    field.redefine { resolve(new_resolve_proc) }
  end
end
