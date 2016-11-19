package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

//mouse input
import flixel.input.mouse.FlxMouseEventManager;

//group
import flixel.group.FlxGroup;

import flixel.util.FlxColor;
import flixel.text.FlxText;

//generico
import genetico.AlgoritmoGenetico;
import genetico.GerentePredio;
import genetico.Predio;
import genetico.PredioSprite;
import genetico.Populacao;

class PlayState extends FlxState
{
	//public
	public var id_predio_atual:Int = 0;
	//private
	var _predios:FlxTypedGroup<PredioSprite>;
	var _textos:FlxTypedGroup<FlxText>;
	var _hud:FlxGroup;
	var _totalText:FlxText;


	//Algoritmo Genetico
	var populacao:Populacao;


	override public function create():Void
	{
		super.create();

		//adiciona state ao RM(Resource Manager)
		RM.playState = this;

		//adiciona o gerenciador de input de mouse haxeflixel
		FlxG.plugins.add(new FlxMouseEventManager());

		//inicializa
		_hud = new FlxGroup();
		_predios = new FlxTypedGroup<PredioSprite>();
		_textos = new FlxTypedGroup<FlxText>();

		add(_predios);
		add(_textos);
		add(_hud);

		//HUD por ultimo

		var base = new FlxSprite(0, 0);
		base.makeGraphic(FlxG.width, Std.int(FlxG.height/20), FlxColor.WHITE);
		base.y = FlxG.height - base.height;

		_hud.add(base);

		_totalText = new FlxText(0, 0);
		_totalText.text = "0";
		_totalText.y = FlxG.height - base.height;
		_totalText.setBorderStyle(OUTLINE, FlxColor.RED, 1);

		_hud.add(_totalText);

		//gera 10 predios randomicamente
		GerentePredio.gerarRandom(10, FlxG.width, Std.int(FlxG.height - base.height) );//para que não aparece ninguem escondino no hud

		for(i in 0...GerentePredio.size()){
			var p:Predio = GerentePredio.get(i);

			var t:FlxText = new FlxText(p.x, p.y, 50);
			t.text = "0";
			t.y -= t.height;
			t.setBorderStyle(OUTLINE, FlxColor.RED, 1);

			var s = new PredioSprite(p.x, p.y);

			s.predio_id = p.id;
			s.label = t;
			s.makeGraphic(p.width, p.height, FlxColor.GREEN);
			_predios.add(s);
			_textos.add(t);
		}



	}

	override public function update(elapsed:Float):Void
	{

		if(FlxG.keys.anyJustPressed(["G"])){
			trace("G");
		}else if(FlxG.keys.anyJustPressed(["F"])){
			trace("fittest");
		}
		super.update(elapsed);

	}


	//public functins

	public function iniciar():Void{
		populacao = new Populacao();
		populacao.iniciar();
		populacao.gerarRandom(50);
	}

	public function evoluir():Void{
		populacao = AlgoritmoGenetico.evoluir(populacao);
	}

	public function update_text(){
		trace("atual");
		trace(GerentePredio.degub_get_dist_from(id_predio_atual));
		_predios.forEach( function ( p:PredioSprite ) : Void {
			if(GerentePredio.distancia(id_predio_atual, p.predio_id) == null){
				trace("if");
				trace(id_predio_atual);
				trace(p.predio_id);
			}
			p.label.text = "" + Std.int(GerentePredio.distancia(id_predio_atual, p.predio_id));
		});
	}

	public function update_lines(){
		//atualizar linha conectando os guardas aos predios

	}

}
