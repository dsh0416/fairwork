# Make sure the session is secured
module Fairwork::Controller
  def fairwork_validate
    p params
    pow = Fairwork::PoW.new(session[:fairwork_iv])
    difficulty = Fairwork::Configure.difficulty.call(self)
    track_id = Fairwork::Configure.track_id.call(self)

    raise Fairwork::Errors::TimestampError if Time.now.to_i - params['fairwork_timestamp'].to_i < 0
    raise Fairwork::Errors::TimestampError if Time.now.to_i - params['fairwork_timestamp'].to_i > Fairwork::Configure.timestamp_expire
    raise Fairwork::Errors::UniqueCtrUsedError if Fairwork::Configure.redis.sismember("fairwork_unique_ctr|#{track_id}", params['fairwork_uniq_ctr'])

    raise PowValidationError unless pow.validate(
      params['fairwork_timestamp'].to_i,
      request.request_method,
      request.path,
      params['fairwork_uniq_ctr'].to_i,
      params['fairwork_nounce'].to_i,
      difficulty)

    Fairwork::Configure.redis.sadd("fairwork_unique_ctr|#{track_id}", params['fairwork_uniq_ctr'])
  end

  def fairwork_initialize
    if session[:fairwork_iv].blank?
      session[:fairwork_iv] = SecureRandom.random_number(2**128)
    end

    render json: { fairwork_iv: session[:fairwork_iv], difficulty: Fairwork::Configure.difficulty.call(self) }
  end
end
