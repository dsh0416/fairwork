# frozen_string_literal: true
class Fairwork::PoW
  attr_reader :session_id
  attr_reader :iv

  def initialize(session_id, iv)
    @session_id = session_id
    @iv = iv
  end

  def validate(timestamp, method, path, uniq_ctr, nounce, difficulty)
    hash = execute(timestamp, method, path, uniq_ctr, nounce)
    hash.start_with?('0' * difficulty)
  end

  def solve(method, path, difficulty)
    timestamp = Time.now.to_i
    uniq_ctr = SecureRandom.random_bytes(16).unpack('C*')
    while true
      nounce = rand(2**64) # Nounce does not have to be crypto secured
      hash = execute(timestamp, method, path, uniq_ctr, nounce)
      if hash.start_with?('0' * difficulty)
        return nounce, timestamp, uniq_ctr
      end
    end
  end

  def execute(timestamp, method, path, uniq_ctr, nounce)
    # bytes are in big endian
    # Session ID (128bit) +
    # iv (128bit) +
    # Unix Timestamp (64bit) +
    # SHA256(Method + Path, 256bit) +
    # Unique Counter (UUID, 128bit) +
    # Nounce (64bit)
    bytes = []

    bytes += @session_id.to_bytes(:big_endian, 8)
    bytes += @iv.to_bytes(:big_endian, 8)
    bytes += timestamp.to_bytes(:big_endian, 4)
    bytes += Digest::SHA256.hexdigest(method + path).to_i(16).to_bytes(:big_endian, 16)
    bytes += uniq_ctr
    bytes += nounce.to_bytes(:big_endian, 4)

    Digest::SHA256.hexdigest(bytes.pack('C*')).to_i(16).to_s(2).rjust(256, '0')
  end
end
