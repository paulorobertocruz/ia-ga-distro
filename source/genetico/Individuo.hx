package genetico;

class Individuo{

  // recursos distribuidos nos predios cadastrados
  var recursos:Map<Int, Recurso>;

  // 1/distancia quanto maior o fitness melhor o Individuo
  var fitness:Float = 0;

  //media das distancias dos predios ate o recurso mais proximo
  var distancia:Float = 0;

  public function new(){
    recursos = new Map<Int, Recurso>();
  }

  public function setRecurso(predio_id:Int, r:Recurso):Void{
    recursos[predio_id] = r;
  }

  public function contemRecurso(predio_id):Bool{
    return recursos.exists(predio_id);
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
    fitness = 0;
    distancia = 0;

  }


  private function get_nearest_recurso(id:Int):Float{
    var dist:Float = -1;
    for( i in recursos.keys()){
      if(dist == -1){
        dist = GerentePredio.distancia(id, i);
      }
      else if(dist > GerentePredio.distancia(id, i)){
        dist = GerentePredio.distancia(id, i);
      }
    }
    return dist;
  }

  public function getRecursos():Array<Predio>{
    var rp:Array<Predio> = [];
    for (i in recursos.keys()){
      rp.push(GerentePredio.get(i));
    }
    return rp;
  }

  public function getRecursoMaisProximo(id:Int):Predio{
    var dist:Float = -1;
    var j:Int = -1;
    for( i in recursos.keys()){
      if(dist == -1){
        dist = GerentePredio.distancia(id, i);
        j = i;
      }
      else if(dist > GerentePredio.distancia(id, i)){
        dist = GerentePredio.distancia(id, i);
        j = i;
      }
    }
    return GerentePredio.get(j);
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
