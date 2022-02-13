##
# Default configuration of Midori, extends +Configurable+
class Fairwork::Configure
  extend Fairwork::Configurable

  set :storage, 'redis://localhost:6379/0'
  set :track_id, proc { |this| this.request.remote_ip }
  set :session_id, proc { SecureRandom.hex(16) }
  set :difficulty_update, proc { |this| 1 }
end
