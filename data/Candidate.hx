package data;

@:rtti
class Candidate {
	@param public var id:String;
	@param public var unsealedAt:Int;
	@param public var riddle:String;
	@param @notNull public var files:Array<UploadedFile>;

	public function new(i:String, r:String) {
		id = i;
		riddle = r;
	}
}