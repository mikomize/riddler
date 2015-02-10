package ;

import data.Card;
import trello.TrelloApi;

import yawf.ObjectMapper;
import yawf.reflections.TypeEnum;

class TrelloRemoteApi implements RemoteApi extends TrelloApi {

	var listId:String;

	public function new(key:String, token:String, listId:String) {
		super(key, token);
		this.listId = listId;
	}
	

	public function getListCards(cb:Array<Card> -> Void) {
		call("/list/" + listId + "/cards", {}, function (r:Dynamic) {
			var t:TypeEnum = TypeEnum.Array(TypeEnum.Class(Card));
			cb(ObjectMapper.fromPlainObjectUntyped(r, t, true));
		});
	}

	public function submitCardComment(cardId:String, comment:String, cb:Void -> Void) {
		trace("comment");
		call("/cards/" + cardId + "/actions/comments", {text:comment}, function(r:Dynamic) {
			cb();
		}, "POST");
	}

	public function cardAttachFile(cardId:String, filePath:String, fileName:String, mimeType:String, cb:Void -> Void) {
		cb();
		/*call("/cards/" + cardId + "/attachments", {url: null}, function (r:Dynamic) {
			trace(r);
			cb();
		}, "POST", filePath);*/
	}
}