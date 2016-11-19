package genetico;

//flixel
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxSprite;

class Predio{

  public var id:Int;

  public var x:Int;

  public var y:Int;

  public var width:Int;

  public var height:Int;

  public var sprite:FlxSprite;

  public function new(xx:Int, yy:Int, w:Int, h:Int){
    x = xx;
    y = yy;
    width = w;
    height = h;
  }

  public function distanciaPara(p:Predio):Float{
    var dx = Math.abs(x - p.x);
    var dy = Math.abs(y - p.y);
    return Math.sqrt(dx * dx + dy * dy);
  }

}
