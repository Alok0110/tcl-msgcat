require 'json'
require "tcl/msgcat/version"
require "tcl/msgcat/catalog"
require "tcl/msgcat/parser"
require "tcl/msgcat/renderer"

module Tcl
  module Msgcat
    def parse(msgcat_file)
      Tcl::Msgcat::Parser.new(msgcat_file).parse
    end

    def render(json_file)
      raise ArgumentError, "File not found" unless File.exist? json_file
      msgs = JSON.parse(File.read(json_file))
      Tcl::Msgcat::Renderer.new(msgs).render
    end

    def merge(root_file, translation_files=[])
      translation_files.each do |file|
        next if File.basename(file) == File.basename(root_file)
        msgs = JSON.parse(File.read(file))
        catalog = Tcl::Msgcat::Catalog.new(msgs)
        catalog.merge!(root)

        File.open(file, "w") {|f| f.write catalog.to_json }
      end
    end
  end
end
