require 'coder'
require 'coder/error'

module Coder
  module Cleaner
    class Java
      def self.available?
        require 'java'
        !!::Java::JavaNioCharset::Charset
      rescue LoadError, NameError
        false
      end

      def self.supports?(encoding)
        encoding.to_s =~ /^utf-8$/i
      end

      def initialize(encoding)
        @encoding = encoding.to_s.upcase
        @nullbyte = "\0"
        @charset  = ::Java::JavaNioCharset::Charset.for_name(encoding)
        @decoder  = @charset.new_decoder
        @decoder.on_malformed_input(::Java::JavaNioCharset::CodingErrorAction::IGNORE)
        @decoder.on_unmappable_character(::Java::JavaNioCharset::CodingErrorAction::IGNORE)
        @nullbyte.encode! encoding if @nullbyte.respond_to? :encode!
      rescue ::Java::JavaNioCharset::UnsupportedCharsetException, ::Java::JavaNioCharset::IllegalCharsetNameException
        raise Coder::InvalidEncoding, "unknown encoding name - #{encoding}"
      rescue ::Java::JavaLang::RuntimeException => e
        raise Coder::Error, e.message, e.backtrace
      end

      def clean(str)
        buffer = ::Java::JavaNio::ByteBuffer.wrap(str.to_java_bytes)
        string = @decoder.decode(buffer).to_s
        Coder.force_encoding!(string, @encoding).gsub(@nullbyte, '')
      rescue Java::JavaLang::RuntimeException => e
        raise Coder::Error, e.message, e.backtrace
      end
    end
  end
end
