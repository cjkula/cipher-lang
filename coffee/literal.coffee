window.Cipher ||= {}

class Cipher.Literal
	
	@matcher: -> "#{Cipher.String.matcher()}|#{Cipher.Numeric.matcher()}"
		