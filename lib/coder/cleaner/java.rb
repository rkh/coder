require 'coder/error'

module Coder
  module Cleaner
    class Java
      def self.available?
        require 'java'
        !!::Java::JavaNioCharset::Charset
      rescue
        false
      end

      def initialize(encoding)
        encoding = encoding.to_s.upcase
        @charset = ::Java::JavaNioCharset::Charset.for_name(encoding)
        @decoder = @charset.new_decoder
        @decoder.on_malformed_input(::Java::JavaNioCharset::CodingErrorAction::IGNORE)
        @decoder.on_unmappable_character(::Java::JavaNioCharset::CodingErrorAction::IGNORE)
      rescue ::Java::JavaNioCharset::UnsupportedCharsetException
        raise Coder::InvalidEncoding, "unknown encoding name - #{encoding}"
      rescue Java::JavaLang::RuntimeException => e
        raise Coder::Error, e.message, e.backtrace
      end

      def clean(str)
        buffer = ::Java::JavaNio::ByteBuffer.wrap(str.to_java_bytes)
        @decoder.decode(buffer).to_s
      rescue Java::JavaLang::RuntimeException => e
        raise Coder::Error, e.message, e.backtrace
      end
    end
  end
end
