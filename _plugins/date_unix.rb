
module Jekyll
  module Filters
    # Format a date according to RFC-822
    #
    # date - The Time to format.
    #
    # Examples
    #
    #   date_to_rfc822(Time.now)
    #   # => "Sun, 24 Apr 2011 12:34:46 +0000"
    #
    # Returns the formatted String.
    def date_to_number(date)
      time(date).to_i
    end

    private
    def time(input)
      case input
      when Time
        input
      when String
        Time.parse(input)
      else
        Jekyll.logger.error "Invalid Date:", "'#{input}' is not a valid datetime."
        exit(1)
      end
    end
  end
end
