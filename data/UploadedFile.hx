package data;

@:rtti
class UploadedFile {
	@param public var originalName:String;
	@param public var path:String;
	@param public var mimeType:String;
	@param public var size:Int;
	@param public var uploadedAt:Int;

	public function new (o:String, s:Int, u:Int, m:String) {
		originalName = o;
		path = uploadedAt + "-" + originalName;
		size = s;
		uploadedAt = u;
		mimeType = m;
	}
}