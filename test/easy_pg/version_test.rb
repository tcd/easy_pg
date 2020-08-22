require "test_helper"
require "rubygems"

class VersionTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil(EasyPg::VERSION)
  end

  def test_that_versions_match
    spec_path = File.join(File.expand_path("../../..", __FILE__), "easy_pg.gemspec")
    spec = Gem::Specification.load(spec_path)
    assert_equal(EasyPg::VERSION, spec.version.to_s)
  end

  def test_readme_links_to_correct_version
    search_string = "[docs]: https://www.rubydoc.info/gems/easy_pg/#{EasyPg::VERSION}"
    readme = File.read(File.join(File.expand_path("../../..", __FILE__), "README.md"))
    assert(readme.include?(search_string))
  end

end
