# frozen_string_literal: true
# Meta-programming Integer Class
class Integer
  def to_bytes(endian, bytesize)
    if endian == :big_endian
      self.to_s(16).rjust(bytesize * 2, '0').scan(/../).map { |a| a.to_i(16) }
    else
      self.to_s(16).rjust(bytesize * 2, '0').scan(/../).map { |a| a.to_i(16) }.reverse
    end
  end
end
