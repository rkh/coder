require 'coder/cleaner/builtin'
require 'coder/cleaner/iconv'
require 'coder/cleaner/simple'

module Coder
  module Cleaner
    Default = [Builtin, Iconv, Simple].detect { |c| c.available? }

    def self.new(encoding)
      Default.new(encoding)
    end
  end
end
