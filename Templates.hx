package;

import js.Node;
import yawf.node.Util;

class Templates {

	var path:String;

	var compiled:Map<String, Dynamic -> String>;

	public function new (path:String) {
		this.path = path;
		
	}

	public function init() {
		compiled = new Map<String, Dynamic -> String>();
		var resolved = Util.resolvePath(path);
		var files:Array<String> = Node.require("fs").readdirSync(resolved);
		for (file in files) {
			var tmp:String = Node.fs.readFileSync(resolved + "/" + file, {encoding: "utf8"});
			compiled[file] = Node.require("underscore").template(tmp);
		}
	}

	public function render(t:String, data:Dynamic = null):String {
		if (data == null) {
			data = {};
		}
		return compiled[t](data);
	}
}