require 'benchmark'
require_relative '../erlang'

include Erlang

puts "Conformance test"

puts "safe_power_fact(65, 60) : #{safe_power_fact(65, 60)}"
puts "power_fact(65, 60) : #{power_fact(65, 60)}"

puts
puts "Performance test"

n = 10000
Benchmark.bm(25) do |x|
  x.report('Erlang::safe_power_fact') { n.times { safe_power_fact(65, 60)  } }
  x.report('Erlang::power_fact')      { n.times { power_fact(65, 60)       } }
end
