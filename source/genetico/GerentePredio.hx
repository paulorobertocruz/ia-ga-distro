
package genetico;

class GerentePredio{

  static var predios:Array<Predio>;

  static var distancias:Array<Array<Float>>;

  static public function init():Void{
    predios = new Array<Predio>();
    distancias = new Array<Array<Float>>();
  }

  static public function size():Int{
    return predios.length;
  }

  static public function add(p:Predio):Void{
    var index:Int = predios.push(p);
    p.id = index - 1;
  }

  static public function get(index:Int):Predio{
    return predios[index];
  }

  static public function gerarRandom(quantidade:Int, max_w:Int, max_h:Int):Void{

    init();

    var width:Int = 8;

    var height:Int = 8;

    var x:Int;

    var y:Int;

    for (i in 0...quantidade){

      x = Std.int(Math.random() * (max_w - (width+1) ) ) + 1;

      y = Std.int(Math.random() * (max_h - (height+1) ) )  + 1;

      var p = new Predio(x, y, width, height);

      add(p);

    }

    calcular_distancias();

  }

  static public function calcular_distancias():Void{

    distancias = [ for(i in 0...predios.length) [for(i in 0...predios.length) 0]];


    for (i in 0...predios.length){
      for (j in 0...predios.length){
        if(i == j){
          distancias[i][j] = 0;
        }else{
          distancias[i][j] = predios[i].distanciaPara(predios[j]);
        }
      }
    }

  }

  static public function distancia(a:Int, b:Int):Float{
    return distancias[a][b];
  }

  static public function degub_get_dist_from(a:Int):Array<Float>{
    return distancias[a];
  }


}
