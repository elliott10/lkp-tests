#!/usr/bin/env ruby

LKP_SRC ||= ENV['LKP_SRC'] || File.dirname(File.dirname File.realpath $PROGRAM_NAME)

require "#{LKP_SRC}/lib/result_root.rb"

collection = MResultRootCollection.new('testcase' => 'unixbench')
stats = {}
total = 0
collection.each { |_rt|
	matrix = _rt.matrix
	matrix.keys.each { |k|
		stats[k] ||= 0
		stats[k] += 1
	}
	total += 1
}

puts "Total: #{total}"
stats.each { |k,v|
	puts "#{k.gsub(',', '.')},#{v}"
}
