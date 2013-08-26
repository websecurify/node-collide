fs = require 'fs'
path = require 'path'
async = require 'async'
coffee_script = require 'coffee-script'

# ---

module.exports = (scripts, callback) ->
	async.map scripts, fs.readFile, (err, results) ->
		return callback err if err
		
		bundle = []
		
		for script, index in scripts
			source = null
			
			try
				source = switch path.extname script
					when '.js' then results[index].toString()
					when '.coffee' then coffee_script.compile results[index].toString()
					else throw new Error "unsupported file type for file #{script}"
			catch e
				return callback e
				
			bundle.push source
			
		return callback null, bundle.join('\n') if callback
