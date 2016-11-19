package genetico;

class Population{

  var individuos:Array<Individuo>;

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
