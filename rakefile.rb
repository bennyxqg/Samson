require 'rubygems'
require 'bundler'
require 'bundler/setup'

require 'rake/clean'
require 'flashsdk'
require 'asunit4'

##
# Set USE_FCSH to true in order to use FCSH for all compile tasks.
#
# You can also set this value by calling the :fcsh task 
# manually like:
#
#   rake fcsh run
#
# These values can also be sent from the command line like:
#
#   rake run FCSH_PKG_NAME=flex3
#
# ENV['USE_FCSH']         = true
# ENV['FCSH_PKG_NAME']    = 'flex4'
# ENV['FCSH_PKG_VERSION'] = '1.0.14.pre'
# ENV['FCSH_PORT']        = 12321

##############################
# Debug

# Compile the debug swf
mxmlc "bin/Samson-debug.swf" do |t|
  t.input = "src/Samson.as"
  t.debug = true
end

desc "Compile and run the debug swf"
flashplayer :run => "bin/Samson-debug.swf"

##############################
# Test

library :asunit4

# Compile the test swf
mxmlc "bin/Samson-test.swf" => :asunit4 do |t|
  
  paths = FileList['test/*.*'] 
  paths.each do |path| 
    filename = path.match(/\/(.+)$/)[1]
    FileUtils.cp path, File.join('bin', filename) 
  end
  
  t.input = "src/SamsonRunner.as"
  t.source_path << 'test'
  t.source_path << 'src'
  t.library_path << 'lib/AS3Futures.swc'
  t.debug = true
end

desc "Compile and run the test swf"
flashplayer :test => "bin/Samson-test.swf"

##############################
# SWC

compc "bin/Samson.swc" do |t|
  t.input_class = "Samson"
  t.source_path << 'src'
  t.include_sources << 'src/org'
  t.external_library_path << 'lib/AS3Futures.swc'
  t.static_rsls = false
end

desc "Compile the SWC file"
task :swc => 'bin/Samson.swc'

##############################
# DOC

desc "Generate documentation at doc/"
asdoc 'doc' do |t|
  t.doc_sources << "src"
  t.exclude_sources << "src/SamsonRunner.as"
end

##############################
# DEFAULT
task :default => :swc

