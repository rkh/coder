# encoding: UTF-8

# JRuby 1.7.0-preview2
#                              user     system      total        real
# Coder::Cleaner::Java     0.360000   0.010000   0.370000 (  0.121000)
# Coder::Cleaner::Iconv    0.290000   0.010000   0.300000 (  0.103000)
# Coder::Cleaner::Simple   1.010000   0.020000   1.030000 (  0.367000)

# MRI 1.9.3
#                               user     system      total        real
# Coder::Cleaner::Builtin   0.060000   0.000000   0.060000 (  0.057767)
# Coder::Cleaner::Iconv     0.020000   0.000000   0.020000 (  0.022351)
# Coder::Cleaner::Simple    0.480000   0.000000   0.480000 (  0.486451)

require 'benchmark'
require 'coder'

strings = [
  "yummy\xE2 \xF0\x9F\x8D\x94 \x9F\x8D\x94",
  "{foo \xC3 'bar'}",
  "yummy 🍔 " * 10
]

Benchmark.bmbm do |x|
  Coder::Cleaner::AVAILABLE.each do |cleaner|
    x.report cleaner.to_s do
      1000.times do
        strings.each do |str|
          cleaner.new('UTF-8').clean(str)
        end
      end
    end
  end
end