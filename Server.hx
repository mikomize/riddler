package;

import controllers.RiddleController;
import controllers.AdminController;

class Server {
	
	public static function main() {
		var app:Riddler = new Riddler();
		app.init(function () {
			app.register(RiddleController);
			app.register(AdminController);
			app.start();
		});
	}
}