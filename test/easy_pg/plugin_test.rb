require "test_helper"

class PluginTest < Minitest::Test

  def test_a_given
    assert_kind_of(Module, EasyPg)
  end

  def test_that_tasks_are_loaded
    Dummy::Application.load_tasks()
    tasks = Rake.application.tasks
  end

end
