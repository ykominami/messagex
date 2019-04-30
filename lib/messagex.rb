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
      addExitCode("EXIT_CODE_CANNOT_MAKE_DIRECTORY")
      addExitCode("EXIT_CODE_CANNOT_CLOSE_FILE")
      addExitCode("EXIT_CODE_CANNOT_OPEN_FILE")
      addExitCode("EXIT_CODE_CANNOT_CLOSE_FILE")
      addExitCode("EXIT_CODE_CANNOT_COPY_FILE")
      addExitCode("EXIT_CODE_ARGV_SIZE")
      addExitCode("EXIT_CODE_ARGV_ERROR")
      addExitCode("EXIT_CODE_NOT_SPECIFIED_FILE")
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

    def outputError(msg)
      if @logger
        @logger.error(msg)
      else
        STDERR.puts(msg)
      end
    end

    def outputFatal(msg)
      if @logger
        @logger.fatal(msg)
      else
        STDERR.puts(msg)
      end
    end

    def outputDebug(msg)
      if @logger
        @logger.debug(msg)
      else
        STDOUT.puts(msg)
      end
    end

    def outputInfo(msg)
      if @logger
        @logger.info(msg)
      else
        STDOUT.puts(msg)
      end
    end

    def outputWarn(msg)
      if @logger
        @logger.warn(msg)
      else
        STDOUT.puts(msg)
      end
    end

    def outputException(ex)
      outputFatal(ex.class)
      outputFatal(ex.message)
      outputFatal(ex.backtrace.join("\n"))
    end

    def exc(msg, exitCodeStr, block)
      begin
        block.call
      rescue IOError =>ex
        outputException(ex)
        outputFatal(msg)
        exit(ec(exitCodeStr))
      rescue SystemCallError =>ex
        outputException(ex)
        outputFatal(msg)
        exit(ec(exitCodeStr))
      end
    end

    def excChangeDirectory(arg1, &block)
      msg="Can't change directory to |#{arg1}|"
      exitCodeStr="EXIT_CODE_CANNOT_CHANGE_DIRECTORY"

      exc(msg, exitCodeStr, block)
    end

    def excFileOpen(arg1, &block)
      msg="Cannot open file #{arg1}"
      exitCodeStr="EXIT_CODE_CANNOT_OPEN_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileRead(arg1, &block)
      msg="Cannot read file #{arg1}"
      exitCodeStr="EXIT_CODE_CANNOT_READ_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileGets(arg1, &block)
      msg="Cannot read file #{arg1}"
      exitCodeStr="EXIT_CODE_CANNOT_READ_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileClose(arg1,  &block)
      msg="Cannot close file #{arg1}"
      exitCodeStr="EXIT_CODE_CANNOT_OPEN_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileWrite(arg1, &block)
      msg="Cannot write file #{arg1}"
      exitCodeStr="EXIT_CODE_CANNOT_WRITE_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileCopy(arg1, arg2, &block)
      msg="Can't copy file from #{arg1} to #{arg2}"
      exitCodeStr="EXIT_CODE_CANNOT_COPY_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excMakeDirectory(arg1, &block)
      msg="Can't make directory to #{arg1}"
      exitCodeStr="EXIT_CODE_CANNOT_MAKE_DIRECTORY"

      exc(msg, exitCodeStr, block)
    end
  end
end
