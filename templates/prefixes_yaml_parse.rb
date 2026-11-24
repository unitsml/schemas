# frozen_string_literal: true

# Emits the prefixes' symbol presentations (ascii) as an XML fragment for
# templates/xsdprocess.xsl (the EnumeratedPrefix enumeration). Reads the
# unitsdb schema 2.2.x structure:
# { "schema_version" => ..., "prefixes" => [ { "symbols" => [{"ascii" => ...}] }, ...] }
require "yaml"
require "open-uri"

items = YAML.safe_load(URI.open(ARGV[0]) { |f| f.read })
puts "<items>"
seen = []
items.fetch("prefixes", []).each do |prefix|
  (prefix["symbols"] || []).each do |symbol|
    ascii = symbol["ascii"]
    next if ascii.nil? || seen.include?(ascii)

    seen << ascii
    puts "<item>#{ascii}</item>"
  end
end
puts "</items>"
