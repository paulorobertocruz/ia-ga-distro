package genetico;

class Individuo{

  // recursos distribuidos nos predios cadastrados
  var recursos:Map<Int, Recurso>;

  // 1/distancia quanto maior o fitness melhor o Individuo
  var fitness:Float;

  //media das distancias dos predios ate o recurso mais proximo
  var distancia:Float;

  public function new(){
    recursos = new Map<Int, Recurso>();
  }

  public function gerarRandom(quantidade:Int):Void{

    recursos = new Map<Int, Recurso>();

    var posibilidades:Array<Int> = [for (i in 0...GerentePredio.size()) i];

    var index:Int;

    var pos:Int;

    for(i in 0...quantidade){

      index = Std.int(Math.random() * posibilidades.length);

      pos = posibilidades[index];

      recursos[pos] = new Recurso();

      posibilidades.remove(pos);

    }

  }


  private function get_nearest_recurso(id:Int):Float{
    var dist:Float = null;
    for( i in recursos.keys()){
      if(dist == null){
        dist = GerentePredio.distancia(id, i);
      }
      else if(dist > GerentePredio.distancia(id, i)){
        dist = GerentePredio.distancia(id, i);
      }
    }
    return dist;
  }

  public function get_distancia():Float{
    if(distancia == 0){
      for(i in 0...GerentePredio.size()){
        distancia += get_nearest_recurso(GerentePredio.get(i).id);
      }
      distancia = distancia / GerentePredio.size();
    }
    fitness = 0;
    return distancia;
  }

  public function get_fitness():Float{
    if(fitness == 0){
      fitness = 1/get_distancia();
    }
    return fitness;
  }
}
