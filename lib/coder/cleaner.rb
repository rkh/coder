require 'coder/cleaner/builtin'
require 'coder/cleaner/iconv'
require 'coder/cleaner/java'
require 'coder/cleaner/simple'

module Coder
  module Cleaner
    ALL = [ Builtin, Java, Iconv, Simple ]
    AVAILABLE = ALL.select { |e| e.available? }

    def self.available?
      AVAILABLE.any?
    end

    def self.supports?(encoding)
      AVAILABLE.any? { |e| e.supports? encoding }
    end

    def self.new(encoding)
      cleaner = AVAILABLE.detect { |e| e.supports? encoding }
      raise Coder::InvalidEncoding, "unknown encoding name - #{encoding}" unless cleaner
      cleaner.new(encoding)
    end
  end
end
