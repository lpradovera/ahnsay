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
      greeting "Hello", :desc => "What to use to greet users"
    end

    # Defining a Rake task is easy
    # The following can be invoked with:
    #   rake plugin_demo:info
    #
    tasks do
      namespace :ahnsay do
        desc "Prints the PluginTemplate information"
        task :info do
          STDOUT.puts "Ahnsay plugin v. #{VERSION}"
        end
      end
    end

  end
end
