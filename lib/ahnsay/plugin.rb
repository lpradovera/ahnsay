module Ahnsay
  class Plugin < Adhearsion::Plugin
    # Actions to perform when the plugin is loaded
    #
    init :ahnsay do
      logger.warn "Ahnsay has been loaded"
    end

    # Basic configuration for the plugin
    #
    config :ahnsay do
      sounds_dir "sounds", :desc => "Name for the application directory that holds the bundled sounds"
    end

    # Defining a Rake task is easy
    # The following can be invoked with:
    #   rake plugin_demo:info
    #
    tasks do
      namespace :ahnsay do
        desc "Prints the Ahnsay information"
        task :info do
          STDOUT.puts "Ahnsay plugin v. #{VERSION}"
        end
      end
    end

  end
end
