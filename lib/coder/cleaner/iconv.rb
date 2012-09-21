require 'coder/error'
require 'stringio'

module Coder
  module Cleaner
    class Iconv
      def self.load_iconv
        return if defined? ::Iconv
        stderr_was, $stderr = $stderr, StringIO.new
        require 'iconv'
      ensure
        $stderr = stderr_was if stderr_was
      end

      def self.new(*)
        load_iconv
        super
      end

      def self.available?
        load_iconv
        !!::Iconv.conv("iso-8859-1//ignore", "utf-8", "\305\253" + "a"*8160)
      rescue Exception => e
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
    end
  end
end
