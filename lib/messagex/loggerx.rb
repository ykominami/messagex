require "logger"

module Messagex
  class Loggerx
    def initialize(fname)
      @loggerSTDOUT = Logger.new(STDOUT)
      @loggerSTDOUT.level = Logger::UNKNOWN
      @loggerSTDOUT.formatter = proc do |severity, _datetime, _progname, msg|
        "#{severity[0]}: #{msg}\n"
      end
      file = File.open(fname, "w")
      @loggerFILE = Logger.new(file)
      @loggerFILE.level = Logger::INFO
      @loggerFILE.formatter = proc do |severity, _datetime, _progname, msg|
        "#{severity}: #{msg}\n"
      end
    end

    def datetime_format=(format)
      @loggerSTDOUT.datetime_format = format
      @loggerFILE.datetime_format = format
    end

    def formatter=(format)
      @loggerSTDOUT.formatter = format
      @loggerFILE.formatter = format
    end

    def level=(value)
      @loggerSTDOUT.level = value
      @loggerFILE.level = value
    end

    def debug(mes)
      @loggerSTDOUT.debug(mes)
      @loggerFILE.debug(mes)
    end

    def error(mes)
      @loggerSTDOUT.error(mes)
      @loggerFILE.error(mes)
    end

    def fatal(mes)
      @loggerSTDOUT.fatal(mes)
      @loggerFILE.fatal(mes)
    end

    def warn(mes)
      @loggerSTDOUT.warn(mes)
      @loggerFILE.warn(mes)
    end

    def info(mes)
      @loggerSTDOUT.info(mes)
      @loggerFILE.info(mes)
    end
  end
end
