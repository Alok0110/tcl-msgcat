module Tcl
  module Msgcat
    module PaddableString

      def rpad(string, count)
        return self if count < 1
        pad = string * count
        pad + self
      end

    end
  end
end