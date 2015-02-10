package trello;

import js.Node;
import haxe.Json;

class TrelloApi {

	var host:String = "https://api.trello.com";
	var version:String = "1";

	var key:String;
	var token:String;

	public function new (k:String, t:String) {
		key = k;
		token = t;
	}

	public function call (endpoint:String, data:Dynamic, callback:Dynamic ->Void, method:String = "GET", file:String = null) {

		data.key = key;
		data.token = token;
		var url:String = host+ "/" + version + endpoint + "?key=" + key + "&token=" + token;
		var opts:Dynamic = {
			uri: url,
			method: method,
			json: true,
			body: data
		};
		//var m:Array<Dynamic> = new Array<Dynamic>();
		//m.push({"content-type": 'application/json', body: Json.stringify(data)});
		//XXX this shit does not work for some unknown reason
		/*
		if (file != null) {
			m.push({body: Node.require("fs").createReadStream(file)});
		}*/
		//opts.multipart = m;
		Node.require("request")(opts, function (error, response, body) {
			trace(body);
			if (!error && response.statusCode == 200) {
				callback(body);
			} else {
				trace(error);
				throw error;
			}
		});
	}
}