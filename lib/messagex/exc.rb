module Messagex
  class Exc
    def initialize(mes)
      @mes = mes
    end

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

    def exc_change_directory(arg1, &block)
      msg = "Can't change directory to |#{arg1}|"
      exit_codestr = "EXIT_CODE_CANNOT_CHANGE_DIRECTORY"
      exc(msg, exit_codestr, block)
    end

    def exc_file_open(arg1, &block)
      msg = "Cannot open file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_OPEN_FILE"
      exc(msg, exit_codestr, block)
    end

    def exc_file_read(arg1, &block)
      msg = "Cannot read file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_READ_FILE"
      exc(msg, exit_codestr, block)
    end

    def exc_file_gets(arg1, &block)
      msg = "Cannot read file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_READ_FILE"
      exc(msg, exit_codestr, block)
    end

    def exc_file_close(arg1, &block)
      msg = "Cannot close file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_OPEN_FILE"
      exc(msg, exit_codestr, block)
    end

    def exc_file_write(arg1, &block)
      msg = "Cannot write file #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_WRITE_FILE"
      exc(msg, exit_codestr, block)
    end

    def exc_file_copy(arg1, arg2, &block)
      msg = "Can't copy file from #{arg1} to #{arg2}"
      exit_codestr = "EXIT_CODE_CANNOT_COPY_FILE"
      exc(msg, exit_codestr, block)
    end

    def exc_make_directory(arg1, &block)
      msg = "Can't make directory to #{arg1}"
      exit_codestr = "EXIT_CODE_CANNOT_MAKE_DIRECTORY"
      exc(msg, exit_codestr, block)
    end
  end
end
