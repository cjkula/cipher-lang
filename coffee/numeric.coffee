window.Cipher ||= {}

class Cipher.Numeric extends Cipher.Object
		
	constructor: (value)->
		@value = value
	
	@matcher: -> '-?\\d*\\.?\\d+'
    
