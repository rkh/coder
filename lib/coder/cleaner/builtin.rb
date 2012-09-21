require 'coder/error'

module Coder
  module Cleaner
    class Builtin
      OPTIONS = { :undef => :replace, :invalid => :replace, :replace => "" }

      def self.available?
        has_encoding? and mri?
      end

      def self.mri?
        !defined?(RUBY_ENGINE) or RUBY_ENGINE == 'ruby'
      end

      def self.has_encoding?
        defined? Encoding.find          and
        defined? EncodingError          and
        String.method_defined? :encode  and
        String.method_defined? :force_encoding
      end

      def initialize(encoding)
        @encoding = encoding.to_s.upcase
        @dummy    = @encoding == 'UTF-8' ? 'UTF-16BE' : 'UTF-8' if needs_dummy?
        @dummy  ||= @encoding

        check_encoding
      end

      def clean(str)
        str = str.dup.force_encoding(@encoding)
        str.encode(@dummy, OPTIONS).encode(@encoding).gsub("\0", "")
      rescue EncodingError => e
        raise Coder::Error, e.message
      end

      private

      def check_encoding
        Encoding.find(@encoding)
      rescue ArgumentError => e
        raise Coder::InvalidEncoding, e.message
      end

      def needs_dummy?
        RUBY_VERSION < '2.0'
      end
    end
  end
end
