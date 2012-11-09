module Ahnsay
  module ControllerMethods
    def sound_path(name)
      multi_path(File.join(Adhearsion.config.ahnsay.sounds_dir, name))
    end

    def multi_path(path)
      path = fname.chomp(File.extname(fname)) if Adhearsion.config.punchblock.platform == :asterisk
      path = "file://" + path if Adhearsion.config.punchblock.platform == :xmpp
      path
    end

  end
end
