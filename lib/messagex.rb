require "messagex/version"
require 'messagex/loggerx'

module Messagex
  class Error < StandardError; end
  # Your code goes here...

  class Messagex
    attr_reader :logger
    attr_reader :exitCode

    def initialize(initialExitCode, initialNum, debug=:warn, logger=nil)
      @exitCode={}
      @currentExitCode=0
      setInitialExitCode(initialExitCode, initialNum)
      
      if logger
        @logger=logger
      else
        @logger = Loggerx.new("log.txt")
        #    @logger.level = Logger::WARN
        #    @logger.level = Logger::INFO
        case debug
        when :debug
          @logger.level = Logger::DEBUG
        # UNKNOWN > FATAL > ERROR > WARN > INFO > DEBUG
        when :verbose
          @logger.level = Logger::INFO
        else
          @logger.level = Logger::WARN
        end
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

    def setInitialExitCode(str, num)
      @exitCode={}
      @exitCode[str]=num
      @curExitCode=num
    end

    def addExitCode(str)
      unless @exitCode[str]
        num=(@curExitCode+1)
        @exitCode[str]=num
        @curExitCode=num
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

    def outputFatal(mes)
      if @logger
        @logger.fatal(mes)
      else
        STDOUT.fatal(mes)
      end
    end
  end
end
