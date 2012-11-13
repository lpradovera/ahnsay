module Ahnsay
  module ControllerMethods
    def sounds_for_time(time, args)
      Ahnsay.sounds_for_time(time, args)
    end

    def sounds_for_number(number)
      Ahnsay.sounds_for_number(number)
    end

    def sounds_for_digits(number)
      Ahnsay.sounds_for_digits(number)
    end
  end
end
