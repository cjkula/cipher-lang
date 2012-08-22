window.Cipher ||= {}

class Cipher.String extends Cipher.Object

	constructor: (value)->
		@value = value
		
	className: 'String'
		
	@matcher: ->
		sgl = "'(\\\\'|[^'])*'"
		dbl = '"(\\\\"|[^"])*"'
		"#{sgl}|#{dbl}"

