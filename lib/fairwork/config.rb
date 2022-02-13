##
# Default configuration of Midori, extends +Configurable+
class Fairwork::Configure
  extend Fairwork::Configurable

  set :redis, nil
  set :track_id, proc { |this| this.request.remote_ip }
  set :difficulty, proc { |this| 1 }
  set :timestamp_expire, 10
end
