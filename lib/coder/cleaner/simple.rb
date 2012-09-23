require 'coder/error'
require 'coder/cleaner/simple/byte_buffer'
require 'coder/cleaner/simple/encodings'

module Coder
  module Cleaner
    class Simple
      def self.available?
        true
      end

      def self.supports?(encoding)
        const_name = encoding.to_s.upcase.gsub('-', '_')
        Encodings.const_defined? const_name
      rescue NameError
        false
      end

      def initialize(encoding)
        const_name = encoding.to_s.upcase.gsub('-', '_')
        raise Coder::InvalidEncoding, "unknown encoding name - #{encoding}" unless self.class.supports? const_name
        @encoding, @name = Encodings.const_get(const_name), encoding
      end

      def clean(str)
        bytes = ByteBuffer.new(@encoding)
        str.each_byte { |b| bytes << b }
        force_encoding bytes.to_s
      end

      private

      def force_encoding(str)
        return str unless str.respond_to? :force_encoding
        str.force_encoding(@name)
      end
    end
  end
end
