module Tcl
  module Msgcat
    class Catalog
      attr_reader :msgs
      def initialize(msgs)
        @msgs = msgs
      end

      def merge!(catalog)
        merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
        @msgs = catalog.msgs.merge(@msgs, &merger)
      end

      def to_json(pretty=true)
        pretty ? JSON.pretty_generate(@msgs) : @msgs.to_json
      end

      def self.load(file)
        msgs = JSON.parse(File.read(file))
        Tcl::Msgcat::Catalog.new(msgs)
      end
    end
  end
end