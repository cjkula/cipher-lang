window.Cipher ||= {}

class Cipher.Block
	
	className: 'Block'
		
	constructor: (parent)->
		@list = []
	
	first: ->
		if @list[0]
			@list[0].first()
		else
			null

	appendValue: (object)->
		if @list.length == 1
	      @list[0].append object
	    else
	      @appendLine new Cipher.Block.Line([object])
		
	appendLine: (line)->
		@list.push line
	

#############################################

class Cipher.Block.Line

	className: 'Line'

	constructor: (objects)->
		@values = objects

	first: ->
		@values[0]
		
	append: (object)->
		@values.push(object)