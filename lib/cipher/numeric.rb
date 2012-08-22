require 'cipher/object'

class Cipher::Numeric < Cipher::Object
  def self.matcher
    '-?\\d*\\.?\\d+'
  end
end
