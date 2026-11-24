# frozen_string_literal: true

# Emits the root units' short symbols as an XML fragment for
# templates/xsdprocess.xsl (the EnumeratedRootUnit enumeration).
# Reads the unitsdb schema 2.2.x structure:
# { "schema_version" => ..., "units" => [ { "short" => ..., "root" => ... }, ...] }
require "yaml"
require "open-uri"

items = YAML.safe_load(URI.open(ARGV[0]) { |f| f.read })
puts "<items>"
seen = []
items.fetch("units", []).each do |unit|
  next unless unit["root"]
  short = unit["short"]
  next if short.nil? || seen.include?(short)

  seen << short
  puts "<item>#{short}</item>"
end
puts "</items>"
