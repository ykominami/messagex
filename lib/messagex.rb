require "messagex/version"
require 'messagex/loggerx'

module Messagex
  class Error < StandardError; end
  # Your code goes here...

  class Messagex
    attr_reader :logger
#    attr_reader :exitCode

    def initialize(initialExitCode, initialNum, debug=:warn, logger=nil, logfname=nil)
      @exitCode={}
      setInitialExitCode(initialExitCode, initialNum)
      
      if logger
        @logger=logger
      else
        logFname=logfname ? logfname : "log.txt"
        @logger = Loggerx.new(logFname)
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

      addExitCode("EXIT_CODE_NORMAL_EXIT")
      addExitCode("EXIT_CODE_CANNOT_READ_FILE")
      addExitCode("EXIT_CODE_CANNOT_WRITE_FILE")
      addExitCode("EXIT_CODE_CANNOT_FIND_FILE_OR_EMPTY")
      addExitCode("EXIT_CODE_CANNOT_FIND_FILE")
      addExitCode("EXIT_CODE_FILE_IS_EMPTY")
      addExitCode("EXIT_CODE_CANNOT_CHANGE_DIRECTORY")
      addExitCode("EXIT_CODE_CANNOT_CLOSE_FILE")
      addExitCode("EXIT_CODE_CANNOT_OPEN_FILE")
      addExitCode("EXIT_CODE_CANNOT_CLOSE_FILE")
      addExitCode("EXIT_CODE_CANNOT_COPY_FILE")
      addExitCode("EXIT_CODE_ARGV_SIZE")
      addExitCode("EXIT_CODE_ARGV_ERROR")
    end

    def ec(name)
      @exitCode[name]
    end

    def setInitialExitCode(name, num)
      @exitCode={}
      @exitCode[name]=num
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

    def outputException(ex)
      outputFatal(ex.class)
      outputFatal(ex.message)
      outputFatal(ex.backtrace.join("\n"))
    end
  end
end
