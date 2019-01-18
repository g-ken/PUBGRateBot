module PUBGRateBot
  class Queue < Array
    alias_method :enqueue, :push
    alias_method :dequeue, :shift
  end
end