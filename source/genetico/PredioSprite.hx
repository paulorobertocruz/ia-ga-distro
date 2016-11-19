package genetico;
/*
class de apresentação da posição dos predios

*/

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.input.mouse.FlxMouseEventManager;

class PredioSprite extends FlxSprite{

  //qual predio este sprite representa
  public var predio_id:Int;

  // qual label este sprite é dono
  public var label:FlxText;

  public function new(X:Float, Y:Float):Void{
    super(X,Y);
    //registra um evento de click de mouse
    FlxMouseEventManager.add(this, onMouseDown);
  }

  public function onMouseDown(ps:PredioSprite):Void{
    RM.playState.id_predio_atual = predio_id;
    RM.playState.update_text();
  }
}
