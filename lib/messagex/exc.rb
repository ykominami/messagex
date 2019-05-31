module Messagex
  #
  # I/O関連例外処理管理クラス
  class Exc
    #
    # 初期化
    #
    # @param mes [Messagex] Messagexクラスのインスタンス
    def initialize(mes)
      @mes = mes
    end

    #
    # I/O関連例外処理
    #
    # @param msg [String] エラーメッセージ
    # @param exit_codestr [String] 終了ステータスの識別名
    # @param block [Proc] Procのインスタンス
    def exc(msg, exit_codestr, block)
      begin
        block.call
      rescue IOError => e
        @mes.output_exception(e)
        @mes.output_fatal(msg)
        exit(@mes.ec(exit_codestr))
      rescue SystemCallError => e
        @mes.output_exception(e)
        @mes.output_fatal(msg)
        exit(@mes.ec(exit_codestr))
      end
    end

    #
    # ディレクトリ移動失敗例外処理
    #
    # @param arg1 [String] 移動しようとしたディレクトリ名
    # @param block [Proc] ブロック引数
    def exc_change_directory(arg1, &block)
      msg = "Can't change directory to |#{arg1}|"
      exit_codestr = "EXIT_CODE_CANNOT_CHANGE_DIRECTORY"
      exc(msg, exit_codestr, block)
    end

    #
    # ファイルオープン失敗例外処理
    #
    # @param arg1 [String] エラーメッセージに組みこむ値
    # @param block [Proc] ブロック引数
    def exc_file_open(arg1, &block)
      msg = "Cannot open file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_OPEN_FILE"
      exc(msg, exit_codestr, block)
    end

    #
    # ファイル読込失敗例外処理
    #
    # @param arg1 [String] 読み込もうとしたファイル名
    # @param block [Proc] ブロック引数
    def exc_file_read(arg1, &block)
      msg = "Cannot read file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_READ_FILE"
      exc(msg, exit_codestr, block)
    end

    #
    # ファイル１行読込失敗例外処理
    #
    # @param arg1 [String] 読み込もうとしたファイル名
    # @param block [Proc] ブロック引数
    def exc_file_gets(arg1, &block)
      msg = "Cannot read file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_READ_FILE"
      exc(msg, exit_codestr, block)
    end

    #
    # ファイルクローズ失敗例外処理
    #
    # @param arg1 [String] クローズしようとしたファイル名
    # @param block [Proc] ブロック引数
    def exc_file_close(arg1, &block)
      msg = "Cannot close file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_OPEN_FILE"
      exc(msg, exit_codestr, block)
    end

    #
    # ファイル書込失敗例外処理
    #
    # @param arg1 [String] 書き込もうとしたファイル名
    # @param block [Proc] ブロック引数
    def exc_file_write(arg1, &block)
      msg = "Cannot write file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_WRITE_FILE"
      exc(msg, exit_codestr, block)
    end

    #
    # ファイルコピー失敗例外処理
    #
    # @param arg1 [String] コピー元ファイル名
    # @param arg2 [String] コピー先ファイル名
    # @param block [Proc] ブロック引数
    def exc_file_copy(arg1, arg2, &block)
      msg = "Can't copy file from #{arg1} to #{arg2}"
      exit_codestr = "EXIT_CODE_CANNOT_COPY_FILE"
      exc(msg, exit_codestr, block)
    end

    #
    # ディレクトリ作成失敗例外処理
    #
    # @param arg1 [String] 作成しようとしたディレクトリ名
    # @param block [Proc] ブロック引数
    def exc_make_directory(arg1, &block)
      msg = "Can't make directory to #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_MAKE_DIRECTORY"
      exc(msg, exit_codestr, block)
    end
  end
end
