#!/opt/local/bin/ruby
# -*- coding: utf-8 -*-

if __FILE__ == $0
  query = <<EOS
SELECT ?person ?team ?height
WHERE {
  ?person a dbpedia-owl:BasketballPlayer;
   dbpedia-owl:team ?team.
  ?person dbpedia-owl:height ?height.
  ?person dbpedia-owl:position ?position.
  ?team dbpprop:conference ?conference.


  FILTER(?conference = <http://dbpedia.org/resource/Western_Conference_(NBA)> ||
              ?conference = <http://dbpedia.org/resource/Eastern_Conference_(NBA)> )
   
  FILTER NOT EXISTS { ?person dbpedia-owl:activeYearsEndYear ?o }
}
ORDER BY DESC(?height)
EOS

  require "sparql/client"
  client = SPARQL::Client.new("http://dbpedia.org/sparql")
  results = client.query(query)

  results.each do |solution|
    print [solution[:person], solution[:team], solution[:position], solution[:height]].join(', ')
    puts
  end
end
