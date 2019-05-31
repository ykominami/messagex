#
# 終了ステータス管理、ログ機能管理のモジュール
module Messagex
  #
  # 終了ステータス管理、ログ機能管理のクラス
  class Messagex
    extend Forwardable

    # @!method exc
    #   @see Exc#exc
    # @!method exc_change_directory
    #   @see Exc#exc_change_directory]
    # @!method exc_file_open
    #   @see Exc#exc_file_open
    # @!method exc_file_read
    #   @see Exc#exc_file_read
    # @!method exc_file_gets
    #   @see Exc#exc_file_gets
    # @!method exc_file_close
    #   @see Exc#exc_file_close
    # @!method exc_file_write
    #   @see Exc#exc_file_write
    # @!method exc_file_copy
    #   @see Exc#exc_file_copy
    # @!method exc_make_directory
    #   @see Exc#exc_make_directory
    def_delegators :@exc_inst, :exc, :exc_change_directory, :exc_file_open, :exc_file_read, :exc_file_gets, :exc_file_close, :exc_file_write, :exc_file_copy, :exc_make_directory

    # @return [Loggerx] Loggerxクラスのインスタンス
    attr_reader :logger

    require "messagex/version"
    require "messagex/loggerx"
    require "messagex/exc"

    #
    # 初期化
    #
    # @param initial_exitcode [String] 最初に登録する終了ステータスの識別名
    # @param initial_num [Integer] 登録する終了ステータスの初期値
    # @param debug [Symbol] ログ機能のログレベル指定 `:debug`、`:verbose`、その他
    # @param logger [Loggerx]　複数のLoggerクラスのインスタンスを持つことが出来るLoggerxクラスのインスタンス
    # @param logfname [String] ログの出力先ファイル名
    # @note 引数debugの値はLoggerクラスのログレベル設定とは指定方法が異なる
    def initialize(initial_exitcode, initial_num, debug=:warn, logger=nil, logfname=nil)
      @exit_code = {}
      set_initial_exitcode(initial_exitcode, initial_num)

      if logger
        @logger = logger
      else
        log_fname = (!logfname.nil? && !logfname.empty?) ? logfname : "log.txt"
        @logger = Loggerx.new(log_fname)
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

      register_exitcodes
    end

    #
    # Messagexクラスで利用する終了ステータスの登録
    #
    # @return [void]
    def register_exitcodes
      add_exitcode("EXIT_CODE_CANNOT_READ_FILE")
      add_exitcode("EXIT_CODE_CANNOT_WRITE_FILE")
      add_exitcode("EXIT_CODE_CANNOT_FIND_DIRECTORY")
      add_exitcode("EXIT_CODE_CANNOT_CHANGE_DIRECTORY")
      add_exitcode("EXIT_CODE_CANNOT_MAKE_DIRECTORY")
      add_exitcode("EXIT_CODE_CANNOT_OPEN_FILE")
      add_exitcode("EXIT_CODE_CANNOT_COPY_FILE")
    end

    #
    # I/O関連例外処理管理クラスのインスタンスの登録
    #
    # @return [void]
    def register_exc
      @exc_inst = Exc.new(self)
    end

    #
    # 識別名で指定された終了ステータスを得る
    #
    # @param name [String] 登録された終了ステータスの識別名
    # @return [Integer] 終了ステータス
    def ec(name)
      @exit_code[name]
    end

    #
    # 終了ステータスの最初の登録
    #
    # @param name [String] 登録する終了ステータスの識別名
    # @param num [Integer] 登録する終了ステータスの値
    # @return [void]
    def set_initial_exitcode(name, num)
      @exit_code ||= {}
      @exit_code[name] = num
      @cur_exit_code = num
    end

    #
    # 終了ステータスの値の自動割り当て
    #
    # @param name [String] 値の自動割り当て対象の終了ステータスの識別名
    # @return [Integer] 自動割り当てされた終了ステータスの値
    def add_exitcode(str)
      return if @exit_code[str]

      num = (@cur_exit_code + 1)
      @exit_code[str] = num
      @cur_exit_code = num
    end

    #
    # ログレベルが ERROR のメッセージを出力
    #
    # @param msg [String] 
    # @return [void]
    def output_error(msg)
      if @logger
        @logger.error(msg)
      else
        error(msg)
      end
    end

    #
    # ログレベルが FATAL のメッセージを出力
    #
    # @param msg [String] 
    # @return [void]
    def output_fatal(msg)
      if @logger
        @logger.fatal(msg)
      else
        STDOUT.puts(msg)
      end
    end

    #
    # ログレベルが DEBUG のメッセージを出力
    #
    # @param msg [String] 
    # @return [void]
    def output_debug(msg)
      if @logger
        @logger.debug(msg)
      else
        STDOUT.puts(msg)
      end
    end

    #
    # ログレベルが INFO のメッセージを出力
    #
    # @param msg [String] 
    # @return [void]
    def output_info(msg)
      if @logger
        @logger.info(msg)
      else
        STDOUT.puts(msg)
      end
    end

    #
    # ログレベルが WARN のメッセージを出力
    #
    # @param msg [String] 
    # @return [void]
    def output_warn(msg)
      if @logger
        @logger.warn(msg)
      else
        STDOUT.puts(msg)
      end
    end

    #
    # ログレベルが ERROR のメッセージを出力
    #
    # @param msg [String] 
    # @return [void]
    def output_exception(exception)
      output_fatal(exception.class)
      output_fatal(exception.message)
      output_fatal(exception.backtrace.join("\n"))
    end
  end
end
