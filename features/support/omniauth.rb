module OmniAuthHelpers
  def google_hash
    {
      info: {
        email: 'example@google.com',
        name: 'John Doe'
      },
      provider: 'google',
      uid: 'https://www.google.com/accounts/o8/id?id=fakeuid'
    }
  end
  module_function :google_hash
end
World(OmniAuthHelpers)

OmniAuth.config.test_mode = true

Before("@omniauth") do
  OmniAuth.config.add_mock(:google, OmniAuthHelpers.google_hash)
end