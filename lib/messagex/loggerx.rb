require "logger"

module Messagex
  #
  # 出力先が標準出力とファイルの２種類をもつログ機能管理クラス
  class Loggerx
    #
    # 初期化
    #
    # @param fname [String] ログの出力先ファイル名
    def initialize(fname)
      @logger_stdout = Logger.new(STDOUT)
      @logger_stdout.level = Logger::UNKNOWN
      @logger_stdout.formatter = proc do |severity, _datetime, _progname, msg|
        "#{severity[0]}: #{msg}\n"
      end
      file = File.open(fname, "w")
      @logger_file = Logger.new(file)
      @logger_file.level = Logger::INFO
      @logger_file.formatter = proc do |severity, _datetime, _progname, msg|
        "#{severity}: #{msg}\n"
      end
    end

    #
    # ログ記録の日時フォーマットの設定
    #
    # @param format [String] ログ記録の日時フォーマット
    # @return [void]
    def datetime_format=(format)
      @logger_stdout.datetime_format = format
      @logger_file.datetime_format = format
    end

    #
    # ログ記録のフォーマットの設定
    #
    # @param format [String] ログ記録のフォーマット
    # @return [void]
    def formatter=(format)
      @logger_stdout.formatter = format
      @logger_file.formatter = format
    end

    #
    # ログレベルの設定
    #
    # @param value [String,Symbol] ログレベル
    # @return [void]
    def level=(value)
      @logger_stdout.level = value
      @logger_file.level = value
    end

    #
    # ログレベルが DEBUG のメッセージを出力
    #
    # @param msg [String] メッセージ
    # @return [void]
    def debug(msg)
      @logger_stdout.debug(msg)
      @logger_file.debug(msg)
    end

    #
    # ログレベルが ERROR のメッセージを出力
    #
    # @param msg [String] メッセージ
    # @return [void]
    def error(msg)
      @logger_stdout.error(msg)
      @logger_file.error(msg)
    end

    #
    # ログレベルが FATAL のメッセージを出力
    #
    # @param msg [String] メッセージ
    # @return [void]
    def fatal(msg)
      @logger_stdout.fatal(msg)
      @logger_file.fatal(msg)
    end

    #
    # ログレベルが WARN のメッセージを出力
    #
    # @param msg [String] メッセージ
    # @return [void]
    def warn(msg)
      @logger_stdout.warn(msg)
      @logger_file.warn(msg)
    end

    #
    # ログレベルが INFO のメッセージを出力
    #
    # @param msg [String] メッセージ
    # @return [void]
    def info(msg)
      @logger_stdout.info(msg)
      @logger_file.info(msg)
    end
  end
end
