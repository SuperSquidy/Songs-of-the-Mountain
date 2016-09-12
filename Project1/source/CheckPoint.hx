package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxG.sound;


class CheckPoint extends FlxSprite
{
	

	public function new(?X:Float=0, ?Y:Float=0){
		super(X, Y);
		loadGraphic('assets/images/Checkpoint_off.png', false, 32, 64); //Checkpoint turned off art
	}

	public function inactiveShrine(){
	}
}