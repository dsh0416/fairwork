# frozen_string_literal: true
module Fairwork::Errors
  class FairworkError < StandardError; end
  
  class TimestampError < FairworkError; end
  class UniqueCtrUsedError < FairworkError; end
  class PowValidationError < FairworkError; end
end
