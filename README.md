# Readme
Here the simple lib to save some results to the context (as simple cache).
As results are saved to the context the lib useful for saving response once per request


# Usage
Please add

```ruby
  require 'graphql/cache_context' # at the top

  # after schema
  use Graphql::CacheContext.new
```

at the top, right after `query Schema`.

If you want to use cache object you have to create your own resolver

```ruby

  resolve ->(company, _arg, _ctx, cache) {
    cache.fetch(:cache_key) { ServicesSome.call }
  }

```

New `cache` object is available as a parametr.

## Methods
For now, we have `fetch` only. The same behavior as `Rails.cache.fetch`: if no data by the key, the block will be applied.

# Usecases

Have no ideas for what someone else needs this gem.

Our case:
- Unfortunately, we have a few fields which send requests to the remote services. We don't want to send the same requests a lot of times.

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
