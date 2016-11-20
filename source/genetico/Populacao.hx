package genetico;

class Populacao{

  var individuos:Array<Individuo>;
  var quantidadeRecursos:Int;

  public function new(res:Int = 3){
    quantidadeRecursos = res;
  }

  public function get(i:Int):Individuo{
    return individuos[i];
  }
  public function getQuantidadeRecursos():Int{
    return quantidadeRecursos;
  }
  public function add(i:Individuo):Void{
    individuos.push(i);
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
    iniciar();
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
