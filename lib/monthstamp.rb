require "monthstamp/version"
require "monthstamp/month"

module Monthstamp
  def monthstamp
   (self.year - 1970) * 12 + self.month - 1
  end
  alias :month_id :monthstamp

  def to_month
    Month.at(monthstamp)
  end

end

require 'date'
require 'time'

Date.send(:include, Monthstamp)
Time.send(:include, Monthstamp)
