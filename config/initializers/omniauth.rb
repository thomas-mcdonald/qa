# fatal error if no providers enabled
if !SiteSettings['authentication'].any? { |_,v| v }
  puts <<END
    You must enable at least one authentication provider in site_settings.yml.

END

  abort
end

# TODO: check all used providers are enabled
# TODO: check enabled providers have the correct environment variables set

Rails.application.config.middleware.use OmniAuth::Builder do
  if SiteSettings.authentication.google
    provider :google_oauth2, ENV['GOOGLE_CLIENT_KEY'], ENV['GOOGLE_CLIENT_SECRET'], name: 'google'
  end
  if SiteSettings.authentication.twitter
    provider :twitter, ENV['TWITTER_CLIENT_KEY'], ENV['TWITTER_CLIENT_SECRET']
  end
end
