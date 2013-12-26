module Blinky
  module DreamCheeky
    module WebmailNotifier
      COLOURS = {
        :black  => "000000",
        :white  => "ffffff",
        :green  => "00ff00",
        :red    => "ff0000",
        :blue   => "0000ff",
        :orange => "ff2a00",
        :teal   => "00ffff",
        :yellow => "ffff00",
        :pink   => "ff00ff"
      }

      COLOURS.each do |name, hex_code|
        define_method(name) do
          colour_hex!(hex_code)
        end
      end

      alias :success! :green
      alias :failure! :red
      alias :building! :blue
      alias :warning! :orange
      alias :off! :black

      def init
        send_data "\x1f\x02\x00\x2e\x00\x00\x2b\x03"
        send_data "\x00\x02\x00\x2e\x00\x00\x2b\x04"
        send_data "\x00\x00\x00\x2e\x00\x00\x2b\x05"
      end

      def colour!(colour)
        send_data(colour + "\x00\x00\x00\x00\x05")
      end

      def colour_rgb!(red, green, blue)
        hex_sequence = [red, green, blue].map(&:chr).join
        colour!(hex_sequence)
      end

      def colour_hex!(hex_code)
        rgb_values = hex_code.scan(/\h{2}/).take(3).map do |n|
          n.to_i(16)
        end

        colour_rgb!(*rgb_values)
      end

      private

      def send_data(data)
        @handle.usb_control_msg(0x21, 0x09, (3 << 8) | 1, 0, data, 0)
      end

    end     
  end
end