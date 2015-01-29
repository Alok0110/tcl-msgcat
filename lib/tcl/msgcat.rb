require 'json'
require "tcl/msgcat/version"
require "tcl/msgcat/catalog"
require "tcl/msgcat/parser"
require "tcl/msgcat/renderer"
require "tcl/msgcat/paddable_string"

class String
  include Tcl::Msgcat::PaddableString
end

module Tcl
  module Msgcat
    class << self
      def parse(msgcat_file)
        Tcl::Msgcat::Parser.new(msgcat_file).parse
      end

      def render(json_file)
        raise ArgumentError, "File not found: #{json_file}" unless File.exist? json_file
        msgs = JSON.parse(File.read(json_file))
        Tcl::Msgcat::Renderer.new(msgs).render
      end

      def merge(root_file, translation_files=[])
        if translation_files.is_a? String
          translation_files = Dir[translation_files]
        end

        root = Tcl::Msgcat::Catalog.load(root_file)

        translation_files.each do |file|
          next if File.basename(file) == File.basename(root_file)
          print "Merging new translations into #{file}... "
          catalog = Tcl::Msgcat::Catalog.load(file)
          catalog.merge!(root)
          File.open(file, "w") {|f| f.write catalog.to_json }
          puts "done"
        end
      end

      def compile(source, target)
        raise ArgumentError, "Not a directory: #{source}" unless File.directory? source
        raise ArgumentError, "Not a directory: #{target}" unless File.directory? target

        Dir["#{source}/*.json"].each do |src|
          dst = File.basename(src, ".json")+".msg"
          print "Compiling #{src} to #{target}/#{dst}... "
          msgs = JSON.parse(File.read(src))
          renderer = Tcl::Msgcat::Renderer.new(msgs).render
          File.write("#{target}/#{dst}") {|f| f.write renderer.to_s }
          puts "done"
        end
      end
    end
  end
end