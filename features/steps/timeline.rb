class Spinach::Features::PostTimelines < Spinach::FeatureSteps
  include SharedPaths
  include SharedQuestion

  step 'I see the created timeline event' do
    should have_content "created this"
  end
end