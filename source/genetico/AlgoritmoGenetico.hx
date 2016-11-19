package genetico;

class AlgoritmoGenetico{

    var taxaMutacao:Float = 0.035;

    var elitismo:Bool = true;

    static public function evoluir(pop:Populacao):Populacao{
      var novaPop:Populacao = new Populacao();
      novaPop.iniciar();


      return pop;
    }

    static public function cruzar():Void{
      
    }

    static public function mutacao():Void{

    }
}
