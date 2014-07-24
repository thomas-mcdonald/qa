require 'active_support/concern'

module Slugger
  extend ActiveSupport::Concern

  def slug
    send(slug_attr).parameterize
  end

  def to_param
    "#{id}#{slug_separator}#{slug}"
  end

  def valid_slug?(url)
    false unless url
    url.split(slug_separator).drop(1).join(slug_separator) == slug
  end

  private

  def slug_separator
    "-"
  end

  module ClassMethods
    def is_slugged(attr)
      class_attribute :slug_attr
      self.slug_attr = attr
    end
  end
end
