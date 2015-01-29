module Tcl
  module Msgcat
    class Renderer
      attr_reader :msgs, :lines
      def initialize(msgs)
        @msgs  = msgs
        @lines = []
      end

      def render
        @lines << "package require mchelper"
        @lines << "msg_lang {}"
        @lines << ""
        _render(@msgs)

        self
      end

      def to_s
        @lines.join("\n")
      end

      private

      # A recursive function that calls itself
      # when the value of a key is a hash so it can
      # iterate through every dimension of the hash
      # to get at the translation labels and strings
      def _render(msgs, level=0)
        msgs.each do |key, value|
          if value.is_a? Hash
            @lines << ""
            @lines << "msgs #{key} {".rpad("  ", level)
            level+=1
            _render(value, level) # render any child hashes or translation labels/strings
            level-=1
            @lines << "}".rpad("  ", level)
            @lines << ""
          end

          if value.is_a? String
            @lines << "m #{key} \"#{value}\"".rpad("  ", level)
          end
        end
      end
    end
  end
end