require 'coder/version'
require 'coder/cleaner'

module Coder
  extend self

  def clean(str, encoding = nil)
    Cleaner.new(encoding || 'UTF-8').clean(str)
  end

  def clean!(str, encoding = nil)
    str.replace clean(str, encoding)
  end
end
