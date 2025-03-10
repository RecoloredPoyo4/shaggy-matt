package;

import Controls.KeyboardScheme;
import flixel.addons.ui.FlxUIButton;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var kadeEngineVer:String = "1.2";
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var bgch:FlxSprite;
	var diff = 1;
	var infoTxt:Array<String> = ['EASY', 'HARD'];
	var info:FlxText;

	override function create()
	{
		Main.god = false;
		Main.skipDes = false;
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bgcol:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuColor'));
		bgcol.scrollFactor.x = 0;
		bgcol.scrollFactor.y = 0;
		//bg.setGraphicSize(Std.int(bg.width * 1.1));
		bgcol.updateHitbox();
		bgcol.screenCenter();
		add(bgcol);

		bgch = new FlxSprite(-80).loadGraphic(Paths.image('menuChars'));
		bgch.scrollFactor.x = 0;
		bgch.scrollFactor.y = 0;
		//bg.setGraphicSize(Std.int(bg.width * 1.1));
		bgch.updateHitbox();
		bgch.screenCenter();
		bgch.y += 500;
		bgch.angle = 180 + 45;
		bgch.antialiasing = true;
		add(bgch);

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		//bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		info = new FlxText(0, 15, 0, infoTxt[diff], 20);
		info.scrollFactor.set();
		info.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		info.screenCenter(X);
		add(info);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer + " FNF - " + kadeEngineVer + " Kade Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		if (FlxG.save.data.nothing == null)
		{
			FlxG.save.data.dfjk = 1;
			FlxG.save.data.offset = 70;
			FlxG.save.data.volume = 0.5;
			FlxG.save.data.newInput = false;
			FlxG.save.data.nothing = false;
			FlxG.save.flush();
		}

		if (FlxG.save.data.mash_punish == null)
		{	
			FlxG.save.data.mash_punish = true;
			FlxG.save.flush();
		}

		if (FlxG.save.data.progress == null)
		{
			FlxG.save.data.progress = 0;
			FlxG.save.flush();
		}
		if (FlxG.save.data.wii == null)
		{
			FlxG.save.data.wii = 0;
			FlxG.save.data.showLetter = false;
			FlxG.save.flush();
		}

		if (FlxG.save.data.dfjk == 1)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else if (FlxG.save.data.dfjk == 0)
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Woops, true);

		changeItem();
		
		//CONTROLS FOR MOBILE
    #if android
	addVirtualPad(FULL, A_B);
  #end
    
		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		bgch.angle -= 0.05;
		if (FlxG.keys.justPressed.F8)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		if (controls.RIGHT_P) diff ++;
		if (controls.LEFT_P) diff --;
		if (diff < 0) diff = 1;
		if (diff > 1) diff = 0;

		Main.diff = diff;
		info.text = '<' + infoTxt[diff] + '>';

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					//FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());
										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});

		//debug resseting progress
		if (FlxG.keys.justPressed.NINE)
		{
			FlxG.sound.play(Paths.sound('burst'));
			FlxG.save.data.wii = 0;
			FlxG.save.data.showLetter = false;
			FlxG.save.flush();
			StoryMenuState.weekUnlocked = [true, true, false, false];
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
