package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 120; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var editor:Bool = false;
	public static var menuBad:Bool = false;
	public static var woops:Bool = false;
	public static var skipDes:Bool = false;
	public static var drums:Bool = false;
	public static var diff = 1;
	public static var keyAmmo:Array<Int> = [4, 6, 9];
	public static var dataJump:Array<Int> = [8, 12, 18];
	public static var god:Bool = false;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		#if android

                if (!FileSystem.exists("/storage/emulated/0/SXMFiles/"))
                {
                    Application.current.window.alert("Make a Folder in Internal Storage (not downloads) named SXMFiles, Then drop the contents of the ZIP there.");
                    System.exit(0);//Will close the game
                }
                else if (!FileSystem.exists("/storage/emulated/0/SXMFiles/files"))
                {
                    Application.current.window.alert("Make a Folder in SXMFiles named Files," + "\nThen drop the contents of assets/assets in the APK there.", + "\n" + "You can also refer to the method used in some Psych Engine ports. This is for Replays" "Check Directory Error");
                    System.exit(0);//Will close the game
                }
                else if (!FileSystem.exists("/storage/emulated/0/SXMFiles/files/assets"))
                {
                    Application.current.window.alert("Try copying assets/assets from apk to " + " /storage/emulated/0/SXMFiles/files" + "\n" + "Press Ok To Close The App", "Check Directory Error");
                    System.exit(0);//Will close the game
                }
                else
                {
                    if (!FileSystem.exists(Main.getDataPath() + "yourthings"))
	            FileSystem.createDirectory(Main.getDataPath() + "yourthings");                   
                }
                #end

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}
