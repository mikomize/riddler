package ;

import data.Card;
interface RemoteApi {
	function getListCards(cb:Array<Card> -> Void):Void;
	function submitCardComment(cardId:String, comment:String, cb:Void -> Void):Void;
	function cardAttachFile(cardId:String, filePath:String, fileName:String, mimeType:String, cb:Void -> Void):Void;
}