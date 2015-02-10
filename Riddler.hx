package ;

import yawf.WebApp;
import haxe.Json;
import js.Node;
import minject.Injector;
import yawf.RequestData;
import yawf.ObjectMapper;
import yawf.reflections.TypeEnum;
import yawf.typedefs.ExpressHttpServerReq;

import data.Card;

class Riddler extends WebApp {

	var templates:Templates;

	public var remoteApi:RemoteApi;

	override public function init(cb:Void -> Void) {
		Node.require("source-map-support").install();
		templates = new Templates("templates");
		templates.init();
		super.init(function () {
			if (conf.get("trello") != null) {
				remoteApi = new TrelloRemoteApi(conf.get("trello:key"), conf.get("trello:token"), conf.get("trello:listId"));
			}

			if (conf.get("assembla") != null) {
				
			}
			cb();
		});
	}

	override function createInjector(requestData:RequestData):Injector {
		var injector:Injector = super.createInjector(requestData);
		injector.mapValue(Riddler, this);
		injector.mapValue(Templates, templates);
		return injector;
	}	

	

	public function getHostname(req:ExpressHttpServerReq):String {
		var tmp:String = req.hostname;
		return tmp == null ? conf.get("ip") + ":" + conf.get("port") : tmp;
	}
}