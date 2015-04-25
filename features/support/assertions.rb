module QA::FeatureAssertions
  def assert_path(path)
    assert_equal(current_path, path)
  end

  def refute_path(path)
    refute_equal(current_path, path)
  end

  def refute_text(*args)
    assert_no_text(*args)
  end
end

Spinach::FeatureSteps.send(:include, QA::FeatureAssertions)
