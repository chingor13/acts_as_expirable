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
acts_as_expirable column: 'some_timestamp'
```

Currently, the only option is for `column`: the name of the ORM's field that you want to treat as the expiry time.
