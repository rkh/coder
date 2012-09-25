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
        result = described_class.new(encoding).clean(from)
        result.should binary_equal(to)
      end
    end
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