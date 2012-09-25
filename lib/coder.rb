require 'coder/version'
require 'coder/cleaner'
require 'coder/error'

require 'coder/ext/active_support' if defined? ActiveSupport

module Coder
  extend self
  DEFAULT_ENCODING = 'UTF-8'

  def clean(str, encoding = DEFAULT_ENCODING)
    Cleaner.new(encoding).clean(str)
  end

  def clean!(str, encoding = DEFAULT_ENCODING)
    str.replace clean(str, encoding)
  end

  def force_encoding!(str, encoding = DEFAULT_ENCODING)
    return str unless str.respond_to? :force_encoding
    str.force_encoding(encoding.to_s)
  end

  def force_encoding(str, encoding = DEFAULT_ENCODING)
    force_encoding! str.dup, encoding
  end
end
