package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	public var _player:Player;
	
	override public function create():Void
	{
		_player = new Player(20,20);	//Starting position of player
		add(_player);
		super.create();
		Reg.state = this;
		Reg._player = _player;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
