package;

import Shrine;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxG.sound;


/*
This file contains information pertaining to the Water Shrine including :
 - Recognizing when the player has interacted with the object
 - Triggering logic & 'cutscenes' & correct story options
 - Unlocking the Player's double jump

 Current Implementation:
 - If the player is in range of the shrine for the first time
 	- The first set of text scrolls, teaching them the song
 - When the player plays the song in range of the shrine for the first time
 	- Second set of text scrolls, player unlocks double jump functionality
 - If the player plays the song in range an additional time(s)
 	- The interaction animation plays, but nothing else
*/

class WaterShrine extends Shrine
{
	public static var songLearned:Bool = false;
	private static var storyLearned:Bool = false;
	
	//Initializing Story-related Variables
	var ticker:TickingText;
	var ticker2:TickingText;
	var ticker3:TickingText;

	override private function create():Void{
		super.create();
		
		//Don't worry about offsets for now
		var tileSizeX = 64;
		var tileSizeY = 64;
		
		//Sprite Sheet & Animations
		loadGraphic('assets/images/Shrines/Water_Shrine_SpriteSheet.png', true, tileSizeX, tileSizeY);
		animation.add("idle", [0], 0, false);
		animation.play("idle", false);
		animation.add("interacted", [1, 2, 3, 4], 2, false);
		animation.finishCallback = finishInteraction;
		animation.add("looping", [2,3,4], 3, true);

		//Initialize Text Assets
		ticker = new TickingText(false, "Watershrine_interact_1.txt", .04, 12, "Water_Text", 100, Std.int(y) - 250);
		ticker2 = new TickingText(false, "Watershrine_text_2.txt", .04, 12, "Water_Text", 100, Std.int(y) - 250);
		ticker3 = new TickingText(false, "Watershrine_after_song_3.txt", .04, 12, "Water_Text", 100, Std.int(y) - 250);
	}
	
	public override function onActivate():Void{		
		if(!songLearned){
			learnSong();
		}
		else if (Reg.mando.getWaterPlayed()){		//If water song was played
			if(!storyLearned)
				learnStory();
			else if (!ticker2.alive){ //Prevents more overlapping
				ticker3.resetText();
				WorldState.instance.add(ticker3);
				ticker3.doSkip = true;
				ticker3.scrollFactor.set(1,1);
			}
			finishInteraction("interacted");
			Reg.mando.waterPlayed(false);
		}
	}

	private function finishInteraction(name:String):Void{
		if (name == "interacted")
			animation.play("looping",true);	
	}

	/*	@function : Triggers scrolling text to learn song
	*/
	private function learnSong(){
		trace("Learning Song");
		songLearned = true;
		WorldState.instance.add(ticker);
		ticker.scrollFactor.set(1,1);
	}

	/*	@function : Triggers the story text
			and Water Song to play
	*/
	private function learnStory(){
		trace("Learning Story");
		FlxG.sound.play("Water_Song");
		Reg.mando.enableWaterSong();
		animation.play("interacted");
		storyLearned = true;
		WorldState.instance.add(ticker2);
		ticker2.scrollFactor.set(1, 1);
		ticker.kill(); //Prevents text overlapping
		
		//Rain Animations
			//rain song file
			FlxG.sound.playMusic("Rain");
			FlxG.sound.music.persist = false; //Music will now maybe not persist between states
		var rain = new FlxSprite(0, 0);
		rain.loadGraphic("assets/images/Shrines/Water_Shrine_Rain.png", true, 640, 480);
		rain.animation.add("rain", [0, 1], 6, true);
		rain.animation.play("rain");
		rain.scrollFactor.set(0, 0);
		rain.setGraphicSize(1280, 960);
		rain.animation.callback = function(s:String, i:Int, j:Int){ rain.set_flipY(FlxG.random.bool()); rain.set_flipX(FlxG.random.bool()); };
		rain.screenCenter();
		rain.set_alpha(.75);
		WorldState.instance.level.foregroundTiles.add(rain);
	}

}