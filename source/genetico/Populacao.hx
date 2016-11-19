package genetico;

class Populacao{

  var individuos:Array<Individuo>;
  var quantidadeRecursos:Int  = 3;

  public function new(){

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
    }
  }


  public function get_fittest():Individuo{

    var indiv:Individuo = individuos[1];

    for (i in 1...individuos.length){
      if(indiv.get_fitness() < individuos[1].get_fitness()){
        indiv = individuos[i];
      }
    }

    return indiv;

  }
}
