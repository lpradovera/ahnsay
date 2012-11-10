require "ahnsay/version"
require "ahnsay/plugin"
require "ahnsay/controller_methods"

module Ahnsay
  class << self
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
        result << ("#{thousands}.ul")
        result << ("thousand.ul")
      end
      rest = number % 1000
      hundreds = (rest / 100).floor
      if hundreds > 0
        result << ("#{hundreds}.ul")
        result << ("hundred.ul")
      end
      rest = rest % 100
      if rest < 19
        result << ("#{rest}.ul")
      else
        tens = (rest / 10).floor
        units = rest % 10
        result << ("#{tens}0.ul")
        result << ("#{units}.ul")
      end
      result.map {|r| sound_path(r) }
    end

    ##
    # Gets the path for a sound file based on configuration and platform
    #
    def sound_path(name)
      Ahnsay.multi_path(File.join(Adhearsion.config.ahnsay.sounds_dir, name))
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
