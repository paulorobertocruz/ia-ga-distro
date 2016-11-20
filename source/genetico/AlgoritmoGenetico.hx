package genetico;

class AlgoritmoGenetico{

    static var quantidadeDeRecursos:Int;

    static var taxaMutacao:Float = 0.035;

    static var tamanho_amostra_rota:Int = 10;

    static var elitismo:Bool = true;

    static public function evoluir(pop:Populacao):Populacao{
      
      quantidadeDeRecursos = pop.getQuantidadeRecursos();
      
      trace("evolução");

      var novaPop:Populacao = new Populacao(pop.getQuantidadeRecursos());
      
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
      
      var filho:Individuo = new Individuo();
      
      var quantidadePai:Int;
      var quantidadeMae:Int; 

      var rp:Array<Predio> = p.getRecursos();
      var rm:Array<Predio> = m.getRecursos();
      
      trace("pai:"+rp.length +" mae:"+ rm.length);

      quantidadePai = Math.ceil(rp.length/2);
      quantidadeMae = Math.floor(rm.length/2);

      //pai 
      for(i in 0...quantidadePai){
        var index:Int = Std.int( Math.random() * rp.length );
        var predio:Predio = rp[index];
        filho.setRecurso(predio.id, new Recurso());
        rp.remove(predio);
      }

      //mae
      for(i in 0...quantidadeMae){        
        var ok:Bool = false;
        var index:Int = -1;
        //certifica que não vai sobreescrever um recurso ja existente no filho
        while( ok == false){
          trace("tentativa_"+i);
          index = Std.int( Math.random() * rm.length );
          if (filho.contemRecurso(index)  == false){
            ok = true;
          }
        }
        
        var predio:Predio = rm[index];
        filho.setRecurso(predio.id, new Recurso());
        rm.remove(predio);
      }
      //não deixa repetir
      return filho;
    }

    static public function mutacao(i:Individuo):Individuo{
      return i;
    }

    static private function seleciona(pop:Populacao):Individuo {

        var sl_pop:Populacao = new Populacao();
        sl_pop.iniciar();

        for (i in 0...tamanho_amostra_rota) {
            //não deixar repetir? usar outro array para retirar possibilidades 

            var randomId:Int = Std.int(Math.random() * pop.size());

            sl_pop.add(pop.get(randomId));
        }

        var fittest:Individuo = sl_pop.get_fittest();

        return fittest;
    }

}
