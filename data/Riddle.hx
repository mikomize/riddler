package data;

@:rtti
class Riddle {
	@param public var name:String;
	@param public var intro:String;
	@param public var problem:String;

	public function new(n:String, i:String, p:String) {
		name = n;
		intro = i;
		problem = p;
	}
}