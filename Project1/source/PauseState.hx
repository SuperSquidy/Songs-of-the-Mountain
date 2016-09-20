package;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.ui.KeyCode;
/**
 * ...
 * @author wrighp
 */
class PauseState extends FlxSubState
{
	private var _overlay:FlxSprite;
	private var _text:Array<TickingText>;
	override public function create():Void 
	{
		super.create();
		_parentState.persistentDraw = true;
		_overlay = new FlxSprite();
		_overlay.makeGraphic(1, 1, FlxColor.WHITE);
		_overlay.scale.set(FlxG.width, FlxG.height);
		_overlay.screenCenter();
		_overlay.scrollFactor.set(0, 0);
		
		add(_overlay);
		FlxG.keys.reset();
		opened();
		
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.TAB){ //Close out window
				this.forEachOfType(TickingText, function(t){t.kill(); });
				close();
		}
	}
	public function opened():Void{
		if (this._created){
			//Fade color overlay in
			FlxTween.color(_overlay, .2, FlxColor.fromRGB(0, 32, 32, 0), FlxColor.fromRGB(0, 32, 32, 128));
			_overlay.alpha = 0;
			FlxTween.tween(_overlay, {alpha : .5}, .2);
			
			//Temporary example of how text will be added
			/*for (i in 0...4){
				var text = new TickingText(true, .04 + .01 * i,24);
				text.y = 80 + 36 * i;
				text.doSkip = false;
				text.allText.push("???????");
				add(text);
			}*/
			
			var text:String;
			
			//These very verbose method chains are because the songs are written backwards in Mandolin.
			for (i in 0...4){
				if (i == 0 && WaterShrine.songLearned){
					var reversedWater = FlxStringUtil.formatArray(Reg.mando.getWaterSong()).split(',');
					reversedWater.reverse();
					text = "Water     " + FlxStringUtil.formatArray(reversedWater);
				}
				else if(i == 1 && Reg.mando.getWindActive()){
					var reversedWind = FlxStringUtil.formatArray(Reg.mando.getWindSong()).split(',');
					reversedWind.reverse();
					text = "Wind     " + FlxStringUtil.formatArray(reversedWind);
				}
				else if(i == 2 && ScarecrowShrine.songLearned){
					var reversedEarth = FlxStringUtil.formatArray(Reg.mando.getEarthSong()).split(',');
					reversedEarth.reverse();
					text = "Earth     " + FlxStringUtil.formatArray(reversedEarth);
				}
				else if(i == 3 && Reg.mando.getStarActive()){
					var reversedStar = FlxStringUtil.formatArray(Reg.mando.getStarSong()).split(',');
					reversedStar.reverse();
					text = "Star     " + FlxStringUtil.formatArray(reversedStar);
				}
				else{
					text = "????????   ? ? ?";
				}
				text = StringTools.replace(text, ",", "   "); //Set the text to be placed in between each keypress.
				createText(.04 + .005 * i,80 + 36 * i,text);
			}
		}
	}
	/**
	 * 
	 * @param	Speed	Interval before every new character is added.
	 * @param	Y		Height of text.
	 * @param	textString	String of text to display.
	 */
	private function createText(Speed:Float, Y:Float, textString:String){
		var text = new TickingText(true,Speed,24);
		text.y = Y;
		text.doSkip = false;
		text.allText.push(textString);
		add(text);
	}
}