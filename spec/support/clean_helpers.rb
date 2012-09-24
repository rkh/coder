module CleanHelpers
  module ClassMethods
    def encoding(encoding, &block)
      return unless described_class.supports? encoding
      context(encoding) do
        let(:encoding) { encoding}
        instance_eval(&block)
      end
    end

    def cleans(from, to = from)
      it "cleans #{from.inspect} to #{to.inspect}" do
        result = described_class.new(encoding).clean(binary(from))
        binary(result).should be == binary(to)
      end
    end
  end

  def binary(str)
    return str unless str.respond_to? :force_encoding
    str.force_encoding('binary')
  end

  def support(encoding)
    be_supports(encoding)
  end

  def self.append_features(obj)
    obj.extend ClassMethods
    obj.subject { obj.described_class }
    super
  end
end