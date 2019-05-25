module Messagex
  class Messagex
    extend Forwardable

    def_delegators :@exc_inst, :exc, :exc_change_directory, :exc_file_open, :exc_file_read, :exc_file_gets, :exc_file_close, :exc_file_write, :exc_file_copy, :exc_make_directory

    attr_reader :logger

    require "messagex/version"
    require "messagex/loggerx"
    require "messagex/exc"

    def initialize(initialExitCode, initialNum, debug=:warn, logger=nil, logfname=nil)
      @exit_code = {}
      set_initial_exitcode(initialExitCode, initialNum)

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
      add_exitcode("EXIT_CODE_CANNOT_READ_FILE")
      add_exitcode("EXIT_CODE_CANNOT_WRITE_FILE")
      add_exitcode("EXIT_CODE_CANNOT_FIND_DIRECTORY")
      add_exitcode("EXIT_CODE_CANNOT_CHANGE_DIRECTORY")
      add_exitcode("EXIT_CODE_CANNOT_MAKE_DIRECTORY")
      add_exitcode("EXIT_CODE_CANNOT_OPEN_FILE")
      add_exitcode("EXIT_CODE_CANNOT_COPY_FILE")
    end

    def register_exc
      @exc_inst = Exc.new(self)
    end

    def ec(name)
      @exit_code[name]
    end

    def set_initial_exitcode(name, num)
      @exit_code = {}
      @exit_code[name] = num
      @cur_exitcode = num
    end

    def add_exitcode(str)
      return if @exit_code[str]

      num = (@cur_exitcode + 1)
      @exit_code[str] = num
      @cur_exitcode = num
    end

    def output_error(msg)
      if @logger
        @logger.error(msg)
      else
        error(msg)
      end
    end

    def output_fatal(msg)
      if @logger
        @logger.fatal(msg)
      else
        STDOUT.puts(msg)
      end
    end

    def output_debug(msg)
      if @logger
        @logger.debug(msg)
      else
        STDOUT.puts(msg)
      end
    end

    def output_info(msg)
      if @logger
        @logger.info(msg)
      else
        STDOUT.puts(msg)
      end
    end

    def output_warn(msg)
      if @logger
        @logger.warn(msg)
      else
        STDOUT.puts(msg)
      end
    end

    def output_exception(e)
      output_fatal(e.class)
      output_fatal(e.message)
      output_fatal(e.backtrace.join("\n"))
    end
  end
end
