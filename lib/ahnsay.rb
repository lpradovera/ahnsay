require "ahnsay/version"
require "ahnsay/plugin"
require "ahnsay/controller_methods"

module Ahnsay
  class << self
    FORMAT_TABLE = {
      "h" => "hour_12h",
      "H" => "hour_24h",
      "m" => "minutes",
      "s" => "seconds",
      "d" => "day",
      "w" => "weekday",
      "M" => "month",
      "Y" => "year",
      "p" => "am_pm",
      "a" => "at"
    }

    ##
    # Main entry point
    # Requires a Time object and a parameter Hash, currently :format
    # Returns an array of sound files with the requested output
    # Example: sound_files_for_time(Time.now, format: "dMYaHm"
    # 
    # format:
    #   h: 12h hour
    #   H: 24h hour
    #   m: minutes
    #   s: seconds
    #   d: day in number
    #   w: weekday name
    #   M: month name
    #   Y: year as "twenty twelve"
    #   p: AM or PM indicator
    #   a: the "at" word
    #   
    def sounds_for_time(time, args={})
      format = args.delete(:format) || 'dMYaHm'
      result = []
      format.each_char do |c|
        result += send("parse_#{FORMAT_TABLE[c]}".to_sym, time)
      end
      result
    end

    ##
    # Parses an "h" character from the main methods
    # Returns the time in AM time.
    # 
    def parse_hour_12h(time)
      files_for_number(time.strftime("%l"))
    end

    ##
    # Parses an "H" character from the main methods
    # Returns the time in 24 time.
    # 
    def parse_hour_24h(time)
      files_for_number(time.strftime("%k"))
    end

    ##
    # Parses a "Y" character from the main methods
    # Returns the numbers for the year in 4 digit format
    # 
    def parse_year(time)
      year = time.strftime("%Y").to_i
      files_for_number(year / 100) + files_for_number(year % 100)
    end

    ##
    # Parses an "M" character from the main methods
    # Returns the month in an array.
    # 
    def parse_month(time)
      [file_for_month(time.strftime("%-m"))]
    end

    ##
    # Parses a "d" character from the main methods
    # Returns the numbers for the day.
    # 
    def parse_day(time)
      files_for_number(time.strftime("%-d"))
    end

    ##
    # Parses a "w" character from the main methods
    # Returns the weekday sound.
    # 
    def parse_weekday(time)
      [file_for_day(time.strftime("%w"))]
    end

    ##
    # Parses a "m" character from the main methods
    # Returns the numbers for the minutes
    # 
    def parse_minutes(time)
      minutes = time.strftime("%M").to_i
      minutes == 0 ? [sound_path("oclock.ul")] : files_for_number(minutes)
    end

    ##
    # Parses a "s" character from the main methods
    # Returns the numbers for the seconds
    # 
    def parse_seconds(time)
      files_for_number(time.strftime("%S"))
    end

    ##
    # Parses a "p" character
    # Returns AM or PM sound files
    #
    def parse_am_pm(time)
      time.strftime("%P") == "am" ? [sound_path("a-m.ul")] : [sound_path("p-m.ul")]
    end

    ##
    # Parses a "a" character
    # Returns a "at" connection
    #
    def parse_at(time)
      [sound_path("at.ul")]
    end

    ##
    # Expects days from 0 to 6 where 0 is Sunday and 6 is Monday
    #
    def file_for_day(day)
      sound_path("day-#{day}.ul")
    end

    ##
    # Expects months from 1 to 12 where 1 is January.
    # Files are actually numbered 0 to 11
    #
    def file_for_month(month)
      sound_path("mon-#{month.to_i - 1}.ul")
    end

    ##
    # Breaks a number down into components.
    # Supports numbers up to 9999
    #
    def files_for_number(number)
      number = number.to_i
      result = []
      thousands = (number / 1000).floor
      if thousands > 0
        result << "#{thousands}.ul" << "thousand.ul"
      end
      rest = number % 1000
      hundreds = (rest / 100).floor
      if hundreds > 0
        result << "#{hundreds}.ul" << "hundred.ul"
      end
      rest = rest % 100
      if rest < 19
        result << "#{rest}.ul"
      else
        tens = (rest / 10).floor
        units = rest % 10
        result << "#{tens}0.ul" 
        result << "#{units}.ul" if units > 0
      end
      result.map {|r| sound_path(r) }
    end

    ##
    # Gets the path for a sound file based on configuration and platform
    #
    def sound_path(name)
      multi_path(File.join(Adhearsion.config.ahnsay.sounds_dir, name))
    end

    ##
    # Massages the file path depending on platform
    #
    def multi_path(path)
      path = path.chomp(File.extname(path)) if Adhearsion.config.punchblock.platform == :asterisk
      path = "file://" + path if Adhearsion.config.punchblock.platform == :xmpp
      path
    end
  end
end
