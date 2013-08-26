fs = require 'fs'
path = require 'path'
less = require 'less'
async = require 'async'

# ---

module.exports = (styles, callback) ->
	async.map styles, fs.readFile, (err, results) ->
		return callback err if err
		
		bundle = []
		
		for style, index in styles
			source = null
			
			try
				source = switch path.extname style
					when '.css' then results[index].toString()
					when '.less' then results[index].toString()
					else throw new Error "unsupported file type for file #{style}"
			catch e
				return callback e
				
			bundle.push source
			
		parser = new less.Parser {
			paths: styles.map (style) -> path.dirname(style)
		}
		
		parser.parse bundle.join('\n'), (err, tree) ->
			return callback err if err
			return callback null, tree.toCSS({compress: true}) if callback
