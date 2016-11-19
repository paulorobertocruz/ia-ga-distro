package genetico;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.input.mouse.FlxMouseEventManager;

class PredioSprite extends FlxSprite{
  public var predio_id:Int;
  public var label:FlxText;

  public function new(X:Float, Y:Float):Void{
    super(X,Y);
    FlxMouseEventManager.add(this, onMouseDown);
  }

  public function onMouseDown(ps:PredioSprite):Void{
    RM.playState.id_predio_atual = predio_id;
    RM.playState.update_text();
  }
}
