require 'cipher/script'

class Cipher::InternalError < StandardError; end
class Cipher::Script::MismatchedIndentation < StandardError; end
class Cipher::Script::ParsingError < StandardError; end
class Cipher::Script::RuntimeError < StandardError; end