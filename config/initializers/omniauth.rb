# fatal error if no providers enabled
if !SiteSettings['authentication'].any? { |k,v| v }
  puts <<END
    You must enable at least one authentication provider in site_settings.yml.

END

  abort
end

Rails.application.config.middleware.use OmniAuth::Builder do
  if SiteSettings.authentication.google
    provider :google_oauth2, ENV['GOOGLE_CLIENT_KEY'], ENV['GOOGLE_CLIENT_SECRET'], name: 'google'
  end
end
