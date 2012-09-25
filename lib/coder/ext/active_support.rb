require 'active_support/json/encoding'

module ActiveSupport::JSON::Encoding
  def self.escape(string)
    json = Coder.force_encoding!(Coder.clean(string), 'binary')
    json.gsub!(escape_regex) { |s| ESCAPED_CHARS[s] }
    json.gsub! /([\xC0-\xDF][\x80-\xBF]|[\xE0-\xEF][\x80-\xBF]{2}|[\xF0-\xF7][\x80-\xBF]{3})+/nx do |s|
      s.unpack("U*").pack("n*").unpack("H*")[0].gsub(/.{4}/n, '\\\\u\&')
    end
    Coder.force_encoding!(%("#{json}"))
  end
end
