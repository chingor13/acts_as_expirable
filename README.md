Acts As Expirable
=================

# Usage

```
class SomeModel < ActiveRecord::Base
  acts_as_expirable
end
```

## Configuration Options

To add configuration options, simply add a Hash of options to the `acts_as_expirable` call:

```
...
acts_as_expirable column: 'some_timestamp'
```

Currently, the only option is for `column`: the name of the ORM's field that you want to treat as the expiry time.
