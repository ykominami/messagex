require "messagex/version"
require 'messagex/loggerx'

module Messagex
  class Error < StandardError; end
  # Your code goes here...
  class Messagex
    attr_reader :logger

    def initialize(debug=false, logger=nil)
      if logger
        @logger=logger
      else
        @logger = Loggerx.new("log.txt")
        #    @logger.level = Logger::WARN
        #    @logger.level = Logger::INFO
        @logger.level = Logger::DEBUG if debug

        # UNKNOWN > FATAL > ERROR > WARN > INFO > DEBUG
        #    @logger.datetime_format = '%Y-%m-%d %H:%M:%S'
        @logger.datetime_format = ''
        #logger.formatter = proc do |severity, datetime, progname, msg|
        #   ">>>>>> #{msg}\n"
        #end
        @logger.formatter = proc do |severity, datetime, progname, msg|
          "#{msg}\n"
        end
      end
    end

    def outputError(mes)
      if @logger
        @logger.error(mes)
      else
        STDERR.puts(mes)
      end
    end

    def outputDebug(mes)
      if @logger
        @logger.debug(mes)
      else
        STDOUT.puts(mes)
      end
    end

    def outputInfo(mes)
      if @logger
        @logger.info(mes)
      else
        STDOUT.info(mes)
      end
    end
  end
end
