class Spinach::Features::PostTimelines < Spinach::FeatureSteps
  include SharedPaths
  include SharedQuestion

  step 'I see the created timeline event' do
    assert_text "created this"
  end
end
