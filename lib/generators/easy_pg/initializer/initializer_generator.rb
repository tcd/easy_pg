# Generate an initializer file for EasyPg.
class InitializerGenerator < Rails::Generators::Base
  desc("This generator creates an initializer file at config/initializers/easy_pg.rb for EasyPg")
  source_root(File.expand_path("templates", __dir__))

  # @return [void]
  def copy_initializer
    template("easy_pg.rb.erb", "config/initializers/easy_pg.rb")
  end

end
