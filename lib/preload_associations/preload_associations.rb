require './lib/preload_associations/active_record_ext'
require './lib/preload_associations/array_ext'

# extend activerecord with the :preload method
ActiveRecord::Base.send(:include, AssociationsPreload::Base)
# add :preload method to array
Array.send(:include, AssociationsPreload::Array)

