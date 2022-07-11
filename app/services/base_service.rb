# frozen_string_literal: true

class BaseService
  def self.perform(*args, &)
    new(*args, &).perform
  end
end
