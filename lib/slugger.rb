require 'active_support/concern'

module QA
  module Slugger
    extend ActiveSupport::Concern

    def slug
      send(slug_attr).parameterize
    end

    def to_param
      "#{id}/#{slug}"
    end

    module ClassMethods
      def is_slugged(attr)
        class_attribute :slug_attr
        self.slug_attr = attr
      end
    end
  end
end