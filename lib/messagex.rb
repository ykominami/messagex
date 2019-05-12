require "messagex/version"

module Messagex
  class Error < StandardError; end
  # Your code goes here...

  class Messagex
    attr_reader :logger

    require "messagex/loggerx"

    def initialize(initialExitCode, initialNum, debug=:warn, logger=nil, logfname=nil)
      @exitCode = {}
      setInitialExitCode(initialExitCode, initialNum)

      if logger
        @logger = logger
      else
        logFname = (!logfname.nil? && !logfname.empty?) ? logfname : "log.txt"
        @logger = Loggerx.new(logFname)
        #    Logger::WARN , Logger::INFO

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
        @logger.datetime_format = ""
        # logger.formatter = proc do |severity, datetime, progname, msg|
        #   ">>>>>> #{msg}\n"
        # end
        @logger.formatter = proc do |_severity, _datetime, _progname, msg|
          "#{msg}\n"
        end
      end

      register_exit_codes
    end

    def register_exit_codes
      addExitCode("EXIT_CODE_CANNOT_READ_FILE")
      addExitCode("EXIT_CODE_CANNOT_WRITE_FILE")
      addExitCode("EXIT_CODE_CANNOT_FIND_DIRECTORY")
      addExitCode("EXIT_CODE_CANNOT_CHANGE_DIRECTORY")
      addExitCode("EXIT_CODE_CANNOT_MAKE_DIRECTORY")
      addExitCode("EXIT_CODE_CANNOT_OPEN_FILE")
      addExitCode("EXIT_CODE_CANNOT_COPY_FILE")
    end

    def ec(name)
      @exitCode[name]
    end

    def setInitialExitCode(name, num)
      @exitCode = {}
      @exitCode[name] = num
      @curExitCode = num
    end

    def addExitCode(str)
      return if @exitCode[str]

      num = (@curExitCode + 1)
      @exitCode[str] = num
      @curExitCode = num
    end

    def outputError(msg)
      if @logger
        @logger.error(msg)
      else
        warn(msg)
      end
    end

    def outputFatal(msg)
      if @logger
        @logger.fatal(msg)
      else
        warn(msg)
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
      rescue IOError => e
        outputException(e)
        outputFatal(msg)
        exit(ec(exitCodeStr))
      rescue SystemCallError => e
        outputException(e)
        outputFatal(msg)
        exit(ec(exitCodeStr))
      end
    end

    def excChangeDirectory(arg1, &block)
      msg = "Can't change directory to |#{arg1}|"
      exitCodeStr = "EXIT_CODE_CANNOT_CHANGE_DIRECTORY"

      exc(msg, exitCodeStr, block)
    end

    def excFileOpen(arg1, &block)
      msg = "Cannot open file #{arg1}"
      exitCodeStr = "EXIT_CODE_CANNOT_OPEN_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileRead(arg1, &block)
      msg = "Cannot read file #{arg1}"
      exitCodeStr = "EXIT_CODE_CANNOT_READ_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileGets(arg1, &block)
      msg = "Cannot read file #{arg1}"
      exitCodeStr = "EXIT_CODE_CANNOT_READ_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileClose(arg1, &block)
      msg = "Cannot close file #{arg1}"
      exitCodeStr = "EXIT_CODE_CANNOT_OPEN_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileWrite(arg1, &block)
      msg = "Cannot write file #{arg1}"
      exitCodeStr = "EXIT_CODE_CANNOT_WRITE_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excFileCopy(arg1, arg2, &block)
      msg = "Can't copy file from #{arg1} to #{arg2}"
      exitCodeStr = "EXIT_CODE_CANNOT_COPY_FILE"

      exc(msg, exitCodeStr, block)
    end

    def excMakeDirectory(arg1, &block)
      msg = "Can't make directory to #{arg1}"
      exitCodeStr = "EXIT_CODE_CANNOT_MAKE_DIRECTORY"

      exc(msg, exitCodeStr, block)
    end
  end
end
