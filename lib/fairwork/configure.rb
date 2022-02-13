##
# Default configuration of Midori, extends +Configurable+
class Fairwork::Configure
  extend Fairwork::Configurable

  set :redis, nil
  set :track_id, proc { |this| this.request.remote_ip }
  set :difficulty, proc { |this|
    reqs = Fairwork::Configure::redis.scard(Fairwork::Configure.track_id.call(this))
    next 0 if reqs == 0
    Math.log(reqs).floor + 1
  }
  set :timestamp_expire, 10
end
