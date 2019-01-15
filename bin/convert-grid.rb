require 'rubygems'
require 'bundler'
require 'pry'
require_relative '../config/es.rb'
Bundler.require :default
require_relative 'generate-id.rb'
data = JSON.load( File.new("data/grid/grid.json") )

client = ROR_ES.client

orgs = []

data["institutes"].each do |org|
  if org["status"] == "active"
      id = RorID.construct
      grid_id_hsh = {"GRID" => {"preferred" => org["id"], "all" => org["id"]}}
      external_ids = org.key?("external_ids") ? org["external_ids"].merge(grid_id_hsh) : grid_id_hsh
    orgs << {
        id: id,
        name: org["name"],
        types: org["types"],
        links: org["links"],
        aliases: org["aliases"],
        acronyms: org["acronyms"],
        wikipedia_url: org["wikipedia_url"],
        labels: org["labels"],
        country: {
            country_code: org["addresses"][0]["country_code"],
            country_name: org["addresses"][0]["country"]
        },
        external_ids: external_ids
    }
  end
end

JSON.dump( {orgs: orgs}, File.open("data/org-id-grid.json", "w") )
