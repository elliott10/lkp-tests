#!/usr/bin/env ruby

LKP_SRC = ENV["LKP_SRC"] || File.dirname(File.dirname File.realpath $PROGRAM_NAME)

require "#{LKP_SRC}/lib/yaml.rb"

tbox_group = 'lkp-hsx02'

testcases = {}
load_yaml("#{LKP_SRC}/etc/index-perf.yaml").each { |k, v|
	testcase = k[0..k.index('.')-1]
	testcases[testcase] ||= []
	testcases[testcase] << k
}

testcases.each { |testcase, metrics|
	puts testcase
	system "lkp collect -c 'testcase=#{testcase}' -c 'tbox_group=#{tbox_group}' -g '(path_params|commit|#{metrics.join('|')})' -o #{testcase}.csv"
}
