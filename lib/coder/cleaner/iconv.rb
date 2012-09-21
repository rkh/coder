require 'coder/error'
require 'stringio'

module Coder
  module Cleaner
    class Iconv
      def self.available?
        quiet { require 'iconv' } unless defined? ::Iconv
        !!::Iconv.conv("iso-8859-1//ignore", "utf-8", "\305\253" + "a"*8160)
      rescue Exception
        false
      end

      def initialize(encoding)
        @iconv = ::Iconv.new("#{encoding}//ignore", encoding.to_s)
      rescue ::Iconv::InvalidEncoding => e
        raise Coder::InvalidEncoding, e.message
      end

      def clean(str)
        @iconv.iconv(str).gsub("\0", "")
      rescue ::Iconv::Failure => e
        raise Coder::Error, e.message
      end

      private

      def quiet
        stderr_was, $stderr = $stderr, StringIO.new
        yield
      ensure
        $stderr = stderr_was
      end
    end
  end
end
