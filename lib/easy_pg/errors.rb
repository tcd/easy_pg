module EasyPg

  # Exceptions raised by EasyPg inherit from `EasyPg::Error`.
  class Error < StandardError; end

  class InvalidFormatError < Error; end

  class InvalidFileExtensionError < Error; end

end
