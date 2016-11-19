package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

//
import flixel.util.FlxSpriteUtil;

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
import genetico.Individuo;

class PlayState extends FlxState
{
	//public
	public var id_predio_atual:Int = 0;

	//private
	var _predios:FlxTypedGroup<PredioSprite>;
	var _textos:FlxTypedGroup<FlxText>;
	var _hud:FlxGroup;
	var _totalText:FlxText;
	var _lines:FlxSprite;


	//Algoritmo Genetico
	var populacao:Populacao;
	var quantidadeRecursos:Int = 10;
	var quantidadeIndividuos:Int = 50;

	var _recursos:FlxTypedGroup<FlxSprite>;


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
		_recursos = new FlxTypedGroup<FlxSprite>();

		add(_predios);
		add(_recursos);
		add(_textos);
		add(_hud);

		//HUD por ultimo

		//sprite onde serão desenhadas as linhas ligando os recursos aos predios
		_lines = new FlxSprite(0,0);
		_lines.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);

		var base = new FlxSprite(0, 0);
		base.makeGraphic(FlxG.width, Std.int(FlxG.height/20), FlxColor.WHITE);
		base.y = FlxG.height - base.height;

		_hud.add(base);

		_totalText = new FlxText(0, 0);
		_totalText.text = "0";
		_totalText.y = FlxG.height - base.height;
		_totalText.setBorderStyle(OUTLINE, FlxColor.RED, 1);

		_hud.add(_totalText);
		_hud.add(_lines);

		//gera 10 predios randomicamente
		GerentePredio.gerarRandom(40, FlxG.width, Std.int(FlxG.height - base.height) );//para que não aparece ninguem escondino no hud

		for(i in 0...GerentePredio.size()){
			var p:Predio = GerentePredio.get(i);

			var t:FlxText = new FlxText(p.x, p.y, 50);
			t.text = "0";
			t.y -= p.height;
			t.setBorderStyle(OUTLINE, FlxColor.RED, 1);

			var s = new PredioSprite(p.x - (p.width/2), p.y - (p.height/2));

			s.predio_id = p.id;
			s.label = t;
			s.makeGraphic(p.width, p.height, FlxColor.GREEN);
			_predios.add(s);
			_textos.add(t);
		}


		iniciar();

	}

	override public function update(elapsed:Float):Void
	{

		if(FlxG.keys.anyJustPressed(["G"])){
			trace("G");
		}else if(FlxG.keys.anyJustPressed(["F"])){
			trace("fittest");
		}else if(FlxG.keys.anyJustPressed(["R"])){
			//reiniciar;
			iniciar();
		}
		super.update(elapsed);

	}


	//public functins

	public function iniciar():Void{

		//remove todos 
		var diff:Int = _recursos.length - quantidadeRecursos;
		
		if(diff > 0 ){
			for(i in 0...diff){
				_recursos.members.pop();
			}
		}else if(diff < 0){
			diff *= -1;
			for(i in 0...diff){
				var r:FlxSprite = new FlxSprite(0, 0);
				r.makeGraphic(8, 8, FlxColor.YELLOW);
				_recursos.add(r);
			}
		}		
		// se for 0 não precisa fazer nada
		
		//gera a população inicial
		populacao = new Populacao(quantidadeRecursos);
		populacao.iniciar();
		populacao.gerarRandom(quantidadeIndividuos);

		update_lines_recursos();
	}

	public function evoluir():Void{
		populacao = AlgoritmoGenetico.evoluir(populacao);
	}

	public function update_text(){
		// trace("atual");
		// trace(GerentePredio.degub_get_dist_from(id_predio_atual));
		_predios.forEach( function ( p:PredioSprite ) : Void {
			p.label.text = "" + Std.int(GerentePredio.distancia(id_predio_atual, p.predio_id));
		});
		
	}

	public function update_lines_recursos(){
		//atualizar linha conectando os guardas aos predios
		_lines.destroy();
		_lines = new FlxSprite(0, 0);
		_lines.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		_hud.add(_lines);		

		//pega o melhor individuo atual
		var fittest:Individuo = populacao.get_fittest();

		//estilo da linha 
		var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 1 };
		var drawStyle:DrawStyle = { smoothing: true };

		//desenha as linhas
		for (i in 0...GerentePredio.size()){
			//desenha linha do predio ate o guarda mais proximo
			var p_a:Predio = GerentePredio.get(i);
			var p_b:Predio = fittest.getRecursoMaisProximo(i);
			if(p_a != p_b){			
				//desenha linha
				FlxSpriteUtil.drawLine(_lines, p_a.x, p_a.y, p_b.x, p_b.y, lineStyle);
			}
		}

		//muda os recursos para os locais certos
		var res:Array<Predio> = fittest.getRecursos();

		for(i in 0...quantidadeRecursos){			
			_recursos.members[i].x = res[i].x - (_recursos.members[i].width/2);
			_recursos.members[i].y = res[i].y - (_recursos.members[i].height/2);
		}

		//atualiza melhor distancia
		_totalText.text = "Total melhor distancia:" + populacao.get_fittest().get_distancia();

	}

}
