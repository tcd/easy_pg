module EasyPg
  # See:
  #
  # - [The Basics of Creating Rails Plugins](https://edgeguides.rubyonrails.org/plugins.html)
  # - [`Rails::Railtie` (Rails API Docs)](https://api.rubyonrails.org/classes/Rails/Railtie.html)
  class Railtie < ::Rails::Railtie
    railtie_name(:easy_pg)
    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load(f) }
    end
  end
end
