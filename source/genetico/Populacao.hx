package genetico;

class Populacao{

  var individuos:Array<Individuo>;
  var quantidadeRecursos:Int  = 3;

  public function new(){

  }

  public function get(i:Int):Individuo{
    return individuos[i];
  }

  public function size():Int{
    return individuos.length;
  }
  //inicializa o array
  public function iniciar():Void{
    individuos = new Array<Individuo>();
  }

  //gera individuos randomizados
  public function gerarRandom(quantidade:Int):Void{
    for (i in 0...quantidade){
      var individuo = new Individuo();
      individuo.gerarRandom(quantidadeRecursos);
      individuos.push(individuo);
    }
  }


  public function get_fittest():Individuo{

    var indiv:Individuo = individuos[0];

    for (i in 1...individuos.length){      
      if(indiv.get_fitness() < individuos[i].get_fitness()){
        indiv = individuos[i];
      }
    }

    return indiv;

  }
}
