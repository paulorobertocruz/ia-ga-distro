package genetico;

class AlgoritmoGenetico{

    var taxaMutacao:Float = 0.035;

    var tamanho_amostra_rota:Int = 10;

    var elitismo:Bool = true;

    static public function evoluir(pop:Populacao):Populacao{
      
      var novaPop:Populacao = new Populacao();

      novaPop.iniciar();
      
      var offset:Int = 0;

      if(elitismo){
        novaPop.add(pop.get_fittest());
        offset = 1;
      }

      for(i in offset...pop.size()){
        
        var pai:Individuo = seleciona(pop);

        var mae:Individuo = seleciona(pop);

        var filho:Individuo = cruzar(pai, mae);

        filho = mutacao(filho);

        novaPop.add(filho);

      }

      return novaPop;
    }

    static public function cruzar(p:Individuo, m:Individuo):Individuo{
      var mae:Individuo;
    }

    static public function mutacao(i:Individuo):Individuo{
      return i;
    }

    static private function seleciona(pop:Populacao):Individuo {

        var sl_pop:Populacao = new Populacao();

        for (i in 0...tamanho_amostra_rota) {
            //não deixar repetir? usar outro array para retirar possibilidades 

            var randomId:Int = Std.int(Math.random() * pop.size());

            sl_pop.add(pop.get(randomId));
        }

        var fittest:Individuo = sl_pop.get_fittest();

        return fittest;
    }

}
