Acts As Expirable
=================

`acts_as_expirable` is an ActiveRecord mixin that enables simple handling of expiring records. It gives you `expired` and `unexpired` scopes as well as global handling of all expirable classes.

## Usage

```
class SomeModel < ActiveRecord::Base
  acts_as_expirable
end
```

## Configuration Options

To add configuration options, simply add a Hash of options to the `acts_as_expirable` call:

```
...
acts_as_expirable column: 'some_timestamp', default: ->(r) { Time.now + 1.day }
```

### Options

* `column` - the name of the ORM's field that you want to treat as the expiry time.
* `default` - a default value to set on create if the expiry field is not yet set. Can be a value or a proc, yielding the record instance.
