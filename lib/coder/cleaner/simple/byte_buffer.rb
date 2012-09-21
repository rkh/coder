module Coder
  module Cleaner
    class Simple
      class ByteBuffer
        attr_accessor :encoding, :bytes, :buffer, :outstanding

        def initialize(encoding)
          @encoding, @bytes = encoding, []
          clear_buffer
        end

        def <<(byte)
          if encoding.garbage? byte, buffer
            clear_buffer
          elsif encoding.single_byte? byte, buffer
            add(byte)
          elsif encoding.multibyte? byte, buffer
            fill_buffer(byte)
          elsif encoding.multibyte_start? byte, buffer
            start_buffer(byte, encoding.multibyte_size(byte, buffer))
          else
            clear_buffer
          end
        end

        def to_s
          bytes.pack('C*')
        end

        private

        def clear_buffer
          start_buffer(nil, 0)
        end

        def start_buffer(byte, size)
          @buffer, @outstanding = Array(byte), size
        end

        def fill_buffer(byte)
          buffer << byte
          add(buffer)  if buffer.size == outstanding
          clear_buffer if buffer.size > outstanding
        end

        def add(input)
          clear_buffer
          bytes.concat Array(input)
        end
      end
    end
  end
end