package controllers;

import yawf.Controller;
import yawf.redis.RedisLayer;
import yawf.Util;
import data.Riddles;
import data.Riddle;
import data.Candidates;
import data.Candidate;
import data.UploadedFile;
import js.Node;
import yawf.ObjectMapper;
import yawf.reflections.TypeEnum;

class RiddleController extends Controller {

	@inject
	public var app:Riddler;

	@inject
	public var redis:RedisLayer;

	@inject
	public var templates:Templates;

	@path("/riddle/:id")
	public function showRiddle(id:String) {
		getAll(id, function (c:Candidate, r:Riddle) {
			var template:String = c.unsealedAt == null ? "sealedRiddle" : "unsealedRiddle";
			var t:TypeEnum = TypeEnum.Array(TypeEnum.Class(UploadedFile));
			requestData.res.send(200, templates.render(template, {riddle: r, candidate: c, moment: Node.require("moment")}));
		});
	}

	@method("POST")
	@path("/riddle/:id")
	public function unsealRiddle(id:String) {
		getAll(id, function (c:Candidate, r:Riddle) {
			if (c.unsealedAt != null) {
				throw "riddle already unsealed!";
			}

			c.unsealedAt = Util.now();
			redis.cache.storeAllDirty(function () {
				app.remoteApi.submitCardComment(id, "Riddle has been unsealed!", function () {
					requestData.res.redirect(302, "/riddle/" + c.id);
				});
			});

			
		});
	}

	@method("POST")
	@path("/riddle/:id/upload")
	public function uploadFile(id:String) {
		var fs = Node.require("fs");
		var form = Type.createInstance(Node.require("multiparty").Form, []);
		getCandidate(id, function (c:Candidate) {
			form.parse(requestData.req, function (err, fields, files) {
				var file = files.solution[0];
				if (file.headers.size == 0) {
					throw "no solution uploaded";
				}
				var uploadedAt:Int = Util.now();
				var uf:UploadedFile = new UploadedFile(file.originalFilename, file.size, uploadedAt, untyped file.headers["content-type"]);
				var to:String = yawf.node.Util.getDirName() + '/static/' + uf.path;
				fs.rename(file.path, yawf.node.Util.resolvePath(to));
				c.files.push(uf);
				redis.cache.storeAllDirty(function () {
					app.remoteApi.cardAttachFile(c.id, to, uf.originalName, uf.mimeType, function () {
						requestData.res.redirect(302, "/riddle/" + c.id);
					});
				});
			});
		});
		
	}

	private function getAll(id:String, cb:Candidate -> Riddle -> Void) {
		getCandidate(id, function(candidate:Candidate) {
			if (candidate == null) {
				throw "Not found";
			}
			getRiddle(candidate.riddle, function (riddle:Riddle) {
				if (riddle == null) {
					throw "Riddle not found";
				}
				cb(candidate, riddle);
			});
		});
	}

	private function getRiddle(id:String, cb:Riddle -> Void) {
		var riddles = redis.cache.get(Riddles);
		riddles.get(id, cb);
	}

	private function getCandidate(id:String, cb:Candidate -> Void) {
		var candidates:Candidates = redis.cache.get(Candidates);
		candidates.get(id, cb);
	}

	private function getFileLink(f:UploadedFile):String {
		return "http://localhost:2999/static/" + f.path;
	}
}