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

MAIN_CLASS = 'Samson'

BUILD_DIR = 'bin'
SWC = "#{BUILD_DIR}/#{MAIN_CLASS}.swc"
SWF_DEBUG = "#{BUILD_DIR}/#{MAIN_CLASS}-debug.swf"
SWF_TEST = "#{BUILD_DIR}/#{MAIN_CLASS}-test.swf"

SRC_DIR = 'src'
SRC_PACKAGE_DIR = "#{SRC_DIR}/org"
SRC_MAIN_FILE = "#{SRC_DIR}/#{MAIN_CLASS}.as"

TEST_SRC_DIR = 'test'
TEST_SRC_MAIN_FILE =  "#{SRC_DIR}/#{MAIN_CLASS}Runner.as"

LIB_DIR = 'lib'

DOCS_DIR = 'docs'

def with(value)
  yield(value)
end

with(SWF_DEBUG) do |file|
  # Compile the debug swf
  mxmlc file do |t|
    t.input = SRC_MAIN_FILE
    t.source_path << SRC_DIR
    t.library_path << LIB_DIR
    t.debug = true
  end

  desc "Compile and run the debug swf"
  flashplayer :run => file
end

##############################
# Test

library :asunit4

# task :start_server do
#   puts 'starting server'
#   
#   @serverPID = Process.fork {
#       TCPServer.open(28561) { |server|
#         loop { 
#           socket = server.accept
#           puts 'processing request'
#           socket << "HTTP/1.0 200 OK\r\n\r\nHello!"
#           socket.close
#         }
#       } 
#   }
#   
#   puts "server started with PID:#{@serverPID}"
# end
# 
# task :stop_server do
#   puts 'stopping server wth PID:#{@serverPID}'
#   Process.kill("HUP", @serverPID)
# end

# Compile the test swf
# with(SWF_TEST) do |file|
#   
#   puts "before task def"
#   
#   mxmlc file => [:asunit4, :start_server] do |t|
#      
#      paths = FileList["#{TEST_SRC_DIR}/*.*"] 
#      paths.each do |path| 
#        filename = path.match(/\/(.+)$/)[1]
#        FileUtils.cp path, File.join(BUILD_DIR, filename) 
#      end
#    
#      t.input = TEST_SRC_MAIN_FILE
#      t.source_path << TEST_SRC_DIR
#      t.source_path << SRC_DIR
#      t.library_path << LIB_DIR
#      t.debug = true
#      
#      # Rake::Task["stop_server"].execute
#    end
# 
#   puts "before task call"
#   desc "Compile and run the test swf"
#   flashplayer :test => file
#   puts "after task call"
#   # puts "killing server"
#   # Process.kill("HUP", @serverPID)
# end
##############################
# SWC

with(SWC) do |file|
  compc file do |t|
    t.input_class = MAIN_CLASS
    t.source_path << SRC_DIR
    t.include_sources << SRC_PACKAGE_DIR
    t.external_library_path << LIB_DIR
    t.static_rsls = false
  end

  desc "Compile the SWC file"
  task :swc => file
end

##############################
# DOC

desc "Generate documentation at doc/"
asdoc DOCS_DIR do |t|
  t.doc_sources << SRC_DIR
  t.exclude_sources << TEST_SRC_MAIN_FILE
end

##############################
# DEFAULT
task :default => :swc

