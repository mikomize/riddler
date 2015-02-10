package controllers;

import yawf.Controller;
import js.Node;


import yawf.redis.RedisLayer;
import data.Riddles;
import data.Riddle;
import data.Candidate;
import data.Candidates;
import data.Card;

class AdminController extends Controller {

	@inject
	public var app:Riddler;

	@inject
	public var templates:Templates;

	@inject
	public var redis:RedisLayer;

	@prefix("/admin")
	public function auth(next:Void -> Void) {
		var user:{name:String, pass:String} = Node.require("basic-auth")(requestData.req);

		if(user == null) {
			return unauthorized();
		}

		if (user.name != conf.get("auth:login") || user.pass != conf.get("auth:pass")) {
			return unauthorized();
		}
		next();
	}

	private function unauthorized() {
	    requestData.res.set('WWW-Authenticate', 'Basic realm=Authorization Required');
    	requestData.res.send(401, "unauthorized");
	}


	@path("/candidate/set")
	public function newCandidate() {
		app.remoteApi.getListCards(function (cards:Array<Card>) {
			var data:Array<{name:String, id:String}> = new Array<{name:String, id:String}>();
			for (card in cards) {
				data.push({name:card.name, id:card.id});
			}

			var riddles:Riddles = redis.cache.get(Riddles);
			riddles.getKeys(function (res:Array<String>) {
				trace(res);
				requestData.res.send(200, templates.render("newCandidate", {cards:data, riddles:res}));
			});
		});

		
	}

	@method("POST")
	@path("/candidate/set")
	public function submitCandidate() {
		var candidates:Candidates = redis.cache.get(Candidates);
		var body:Dynamic = requestData.req.body;
		var candidate:Candidate = new Candidate(body.id, body.riddle);
		candidates.set(body.id, candidate);
		redis.cache.storeAllDirty(function () {
			var host:String = app.getHostname(requestData.req); 
			var link:String =  requestData.req.protocol + "://" + host + "/riddle/" + body.id;
			app.remoteApi.submitCardComment(body.id, "New test set for candidate, available at:\n " + link, function () {
				requestData.res.send(200, "Done!");
			});
		});
	}

	@path("/riddle/new")
	public function newRiddle() {
		requestData.res.send(200, templates.render("newRiddle"));
	}

	@method("POST")
	@path("/riddle/new")
	public function submitRiddle() {
		var r:Riddles = new Riddles();
		
		var riddles:Riddles = redis.cache.get(Riddles);
		var body:Dynamic = requestData.req.body;
		var riddle:Riddle = new Riddle(body.name, body.intro, body.problem);
		riddles.set(body.name, riddle);
		redis.cache.storeAllDirty(function () {
			requestData.res.send(200, "Done!");
		});

	}



}