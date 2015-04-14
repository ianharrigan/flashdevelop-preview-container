package haxeui.flashdevelop.preview;

import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.themes.GradientTheme;
import openfl.external.ExternalInterface;

class Main {
	private static var _main:MainController;
	
	public static function main() {
		Toolkit.theme = new GradientTheme();
		Toolkit.init();
		Toolkit.addStyleSheet("css/main.css");
		Toolkit.open(function(root:Root) {
			_main = new MainController();
			try {
				ExternalInterface.addCallback("updateLayout", function(layoutString:String) {
					_main.updateLayout(layoutString);
				});
				
				ResourceManager.instance.resourceHook = new FDResourceHook();
				
				ExternalInterface.call("callbacksReady");
			} catch (e:Dynamic) {
				trace("ERROR: " + e);
			}
			
			root.addChild(_main.view);
		});
	}
}
