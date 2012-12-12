module Coder
  module Cleaner
    class Simple
      module Encodings
        # Note: This currently does not remove most overlong forms
        module UTF_8
          extend self

          def garbage?(input, buffered)
            return true if input > 244 or input == 192 or input == 193
            case buffered <=> [244, 143, 191]
            when -1 then false
            when  0 then input < 192
            when  1 then true
            end
          end

          def single_byte?(input, buffered)
            input.between? 1, 127
          end

          def multibyte?(input, buffered)
            input.between? 128, 244
          end

          def multibyte_start?(input, buffered)
            input.between? 192, 244
          end

          def multibyte_body?(input, buffered)
            input.between? 128, 191
          end

          def multibyte_size(input, buffered)
            case input
            when 192..223 then 2
            when 224..239 then 3
            when 240..247 then 4
            when 248..244 then 5
            when 001..127 then 1
            else 0
            end
          end
        end

        module UCS_2BE
          extend self

          def garbage?(input, buffered)
            return false unless buffered.size + 1 == multibyte_size
            return true if codepoint(buffered + [input]) > 0x10FFFF
            input == 0 and buffered.all? { |b| b == 0 }
          end

          def single_byte?(input, buffered)
            false
          end

          def multibyte?(input, buffered)
            true
          end

          def multibyte_start?(input, buffered)
            buffered.size % multibyte_size == 0
          end

          def multibyte_body?(input, buffered)
            not multibyte_start? input, buffered
          end

          def multibyte_size(*)
            2
          end

          def codepoint(values)
            values.inject { |a,b| (a << 8) + b }
          end
        end

        module UCS_4BE
          include UCS_2BE
          extend self

          def multibyte_size(*)
            4
          end
        end
      end
    end
  end
end