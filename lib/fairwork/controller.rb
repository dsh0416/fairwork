# Make sure the session is secured
module Fairwork::Controller
  def fairwork_validate
    pow = Fairwork::PoW.new(session[:fairwork_iv])
    difficulty = Fairwork::Configure.difficulty.call(self)

    raise Fairwork::Errors::DifficultyMismatched if difficulty > request[:difficulty]
    raise Fairwork::Errors::TimestampError if Time.now.to_i - request[:fairwork_timestamp] < 0
    raise Fairwork::Errors::TimestampError if Time.now.to_i - request[:fairwork_timestamp] > Fairwork::Configure.timestamp_expire
    raise Fairwork::Errors::UniqueCtrUsedError unless Fairwork::Configure.redis.sismember('fairwork_unique_ctr', request[:fairwork_uniq_ctr])

    raise PowValidationError unless pow.validate(
      request[:fairwork_timestamp],
      request.request_method,
      request.path,
      request[:fairwork_uniq_ctr],
      request[:fairwork_nounce],
      difficulty)

    Fairwork::Configure.redis.sadd('fairwork_unique_ctr', request[:fairwork_uniq_ctr])
  end

  def fairwork_initialize
    if session[:fairwork_iv].blank?
      session[:fairwork_iv] = SecureRandom.random_bytes(16)
    end
  end
end
