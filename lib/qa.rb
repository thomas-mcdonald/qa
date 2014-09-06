require 'jobs'
require 'pipeline'

module QA
  class NotAuthorised < Exception; end
  class NotLoggedIn < Exception; end
end