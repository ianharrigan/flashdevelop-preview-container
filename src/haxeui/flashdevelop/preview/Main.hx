package haxeui.flashdevelop.preview;

import format.svg.Grad;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.themes.DefaultTheme;
import haxe.ui.toolkit.themes.GradientMobileTheme;
import haxe.ui.toolkit.themes.GradientTheme;
import haxe.ui.toolkit.themes.Theme;
import openfl.external.ExternalInterface;

class Main {
	private static var _main:MainController;
	private static var _layoutString:String;
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
					_layoutString = layoutString;
					_main.updateLayout(layoutString);
				});

				ExternalInterface.addCallback("setTheme", function(theme:String) {
					trace("Setting theme to: " + theme);
					StyleManager.instance.clear();
					var t:Theme = null;
					
					switch (theme) { // TODO: make this dynamic once theme system has been improved (Issue #121)
						case "Default":
							t = new DefaultTheme();
						case "Gradient":
							t = new GradientTheme();
						case "Gradient Mobile":
							t = new GradientMobileTheme();
					}
					
					if (t != null) {
						t.apply();
						root.removeAllChildren();
						_main = new MainController();
						root.addChild(_main.view);
						_main.updateLayout(_layoutString);
					}
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
