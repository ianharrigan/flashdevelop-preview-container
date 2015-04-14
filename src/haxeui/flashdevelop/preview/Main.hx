package haxeui.flashdevelop.preview;

import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.themes.GradientTheme;
import openfl.external.ExternalInterface;

class Main {
	private static var _main:MainController;
	private static var _originalTrace = haxe.Log.trace;
	
	public static function main() {
		haxe.Log.trace = fdTrace;
		
		Toolkit.theme = new GradientTheme();
		Toolkit.init();
		Toolkit.addStyleSheet("css/main.css");
		Toolkit.open(function(root:Root) {
			_main = new MainController();
			try {
				ExternalInterface.addCallback("updateLayout", function(layoutString:String) {
					_main.updateLayout(layoutString);
				});
				
				ExternalInterface.addCallback("redirectTrace", function(redirect:String) {
					trace("redirect = " + redirect);
				});
				
				ResourceManager.instance.resourceHook = new FDResourceHook();
				
				ExternalInterface.call("callbacksReady");
			} catch (e:Dynamic) {
				trace("ERROR: " + e);
			}
			
			root.addChild(_main.view);
		});
	}
	
	public static function fdTrace(v:Dynamic, ?inf:haxe.PosInfos) {
		try {
			var s:String = inf.fileName + ":" + inf.lineNumber + ": " + v;
			ExternalInterface.call("trace", s);
		} catch (e:Dynamic) {
			
		}
	}
}
