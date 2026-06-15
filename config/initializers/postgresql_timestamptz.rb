# frozen_string_literal: true

# Store all datetime columns as `timestamptz` instead of the Rails default
# `timestamp without time zone`, so `t.datetime` and `t.timestamps` are
# timezone-aware at the database level.
ActiveSupport.on_load(:active_record_postgresqladapter) do
  self.datetime_type = :timestamptz
end
