class Month

  MONTHNAMES ||= ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"].freeze
  MONTHDOWNCASENAMES ||= MONTHNAMES.map(&:downcase).freeze
  MONTHMAP ||= Hash[*MONTHDOWNCASENAMES.each_with_index.map{|monthname,index| [monthname, index + 1]}.flatten].freeze

  include Monthstamp

  attr_accessor :year, :month

  class InvalidMonth < RuntimeError
  end
  class InvalidYear < RuntimeError
  end


  def initialize month, year
    self.month = month
    self.year = year
  end

  class << self
    def at(monthstamp)
      monthstamp = Integer(monthstamp)
      year = (monthstamp / 12) + 1970
      month = monthstamp % 12 + 1
      new(month, year)
    end
    alias :find :at

    def parse(string)
      dt = DateTime.parse(string)
      new(dt.month,dt.year)
    end

    def dump(month)
      month.monthstamp
    end

    def load(monthstamp)
      at(monthstamp)
    end

    def now
      at(Date.today.monthstamp)
    end

  end

  def == other
    other && other.month == self.month && other.year == self.year
  end
  alias :eql? :==

  def hash
    monthstamp.hash
  end

  def <=> other
    monthstamp <=> other.monthstamp
  end

  def name
    month_name + " " + year.to_s
  end

  def month_name
    MONTHNAMES[month - 1]
  end

  def short_name year_first_month_only = false
    if year_first_month_only
      if number == 1
        short_month_name + " " + year.to_s
      else
        short_month_name
      end
    else
      short_month_name + " " + year.to_s
    end
  end

  def short_month_name
    month_name[0..2]
  end

  def to_param
    id.to_s
  end

  def inspect
    short_name(false)
  end

  def month
    number
  end

  def number
    @month.to_i
  end

  def year
    @year.to_i
  end

  def id
    monthstamp
  end

  def month= m
    @month =
      if m.is_a? Integer
        m
      elsif m =~ /\d+/
        m.to_i
      elsif m.respond_to?(:downcase)
        i = MONTHDOWNCASENAMES.index(m.downcase)
        i.nil? ? nil : i + 1
      end.tap { |x|
        raise InvalidMonth, "Invalid month #{x.inspect}" unless x && x <= 12 && x >= 1
      }
  end

  def year= y
    @year = y.to_i.tap{|x| raise InvalidYear, "Cant handle years before 1970! year:#{x}" unless x >= 1970 }
  end

  def strftime *args
    date_object.strftime(*args)
  end

  def last_year
    Month.at(monthstamp - 12)
  end

  def next_year
    Month.at(monthstamp + 12)
  end

  def last_month
    Month.at(monthstamp - 1)
  end

  def next_month
    Month.at(monthstamp + 1)
  end
  alias :succ :next_month

  def first_day
    date_object.beginning_of_month
  end

  def last_day
    date_object.end_of_month
  end

  def dates
    (first_day..last_day)
  end

  def < other
    self.monthstamp < other.monthstamp
  end

  def start_date
    Date.new(year,month,1)
  end

  def > other
    self.monthstamp > other.monthstamp
  end

  def number_of_days
    Time.days_in_month(month, year)
  end

  def to_s
    "#{month}-#{year}"
  end

  private

  def date_object
    Date.new(year, month)
  end

end

