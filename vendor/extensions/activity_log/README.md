Activity log for Radiant
------------------------

## Migrate existing activity:

```ruby
Asset.find(:all, :conditions => 'updated_by_id is not null').each { |a| a.track_activity("updated", a.updated_by, a.updated_at) }

Page.find(:all, :conditions => 'updated_by_id is not null').each { |a| a.track_activity("updated", a.updated_by, a.updated_at) }
```

## Todo

* Tests
