module Tcl
  module Msgcat

    # Parses a msgcat file into a ruby hash
    # which can then be converted to whatever
    class Parser
      attr_reader :msgs

      def initialize(file)
        raise ArgumentError, "File not found" unless File.exist? file

        @msgs = {}
        @file = file
      end

      def parse
        lines  = File.read(@file).lines
        scopes = []

        # strip the comments out
        lines.reject! {|l| l.match(/^\s?#/) }

        # run through each line and do an action
        # depending on the kind of line it is
        lines.each do |line|

          # start of a message group/namespace definition
          if match = line.match(/msgs (\S+) \{/)  # msg ::site::irrigation {
            scopes << match[1]
            next
          end

          # end of the message group/namespace definition
          if match = line.match(/\}/)             # }
            scopes.pop
            next
          end

          # an actual message definition
          if match = line.match(/m (\S+) "(.+)"/) # m label "the actual string"
            add(scopes, match[1], match[2])
          end
        end

        self
      end

      # Adds a key and translation to the msg hash
      #
      # Uses eval to dynamically create a multi dimensional
      # hash from the scopes array that is given
      #
      def add(scopes, name, string)
        chain = []

        # run through each scope
        scopes.each_with_index do |k, i|
          chain = []
          
          # build the chain of send commands from the top level
          # to the level of the current scope, for each iteration
          #
          # e.g. for iteration:
          #
          # first:  hash[:scope1]
          # second: hash[:scope1][:scope2]
          # third:  hash[:scope1][:scope2][:scope3]
          subkeys = scopes[0..i]
          subkeys.each do |k|
            chain << "send('[]', '#{k}')"
          end

          # if the (sub)key doesn't exist for this (chain of) scopes
          # then set it to an empty hash
          if eval("@msgs.#{chain.join(".")}").nil?
            set_chain = chain[0..-2] + ["send('[]=', '#{subkeys.last}', {})"]
            eval("@msgs.#{set_chain.join(".")}")
          end
        end

        # set the value a the end of the chain
        chain << "send('[]=', '#{name}', %q[#{string}])"
        eval("@msgs.#{chain.join(".")}")
      end

      def to_json(pretty=true)
        pretty ? JSON.pretty_generate(@msgs) : @msgs.to_json
      end
    end
  end
end