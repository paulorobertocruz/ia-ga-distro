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
	var _btns:FlxTypedGroup<FlxButton>;

	//controle
	var _play:Bool = false;
	var _geracao:Int = 1;

	var _btnPlay:FlxButton;
	var _btnEvoluir:FlxButton;

	//Algoritmo Genetico
	var populacao:Populacao;
	var quantidadeRecursos:Int = 10;
	var quantidadeIndividuos:Int = 50;
	var quantidadePredios:Int = 50;

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
		_btns = new FlxTypedGroup<FlxButton>();

		add(_predios);
		add(_recursos);
		add(_textos);

		//HUD por ultimo, trocar por substate para o hud acompanhar a camera
		add(_hud);


		//btns
		add(_btns);
		var heightBtn:Int = FlxG.height - Std.int(FlxG.height/20) - 5;
		var _btnResetar = new FlxButton(400, heightBtn, "Reiniciar", function() : Void {
			_geracao = 1;
			_play = false;
			_btnPlay.text = "play";
			iniciar();
		});

		_btnPlay = new FlxButton(_btnResetar.x + _btnResetar.width, heightBtn, "play", function(){
			if(_play){
				_play = false;
				this._btnPlay.text = "play";
			}
			else{
				_play = true;
				this._btnPlay.text = "pause";
			}
		});

		_btnEvoluir  = new FlxButton(_btnPlay.width + _btnPlay.x, heightBtn, ">>", function(){
			_geracao += 1;
			evoluir();
			update_lines_recursos();
		});
		_btns.add(_btnResetar);
		_btns.add(_btnPlay);
		_btns.add(_btnEvoluir);

		var base = new FlxSprite(0, 0);
		base.makeGraphic(FlxG.width, Std.int(FlxG.height/20), FlxColor.YELLOW);
		base.y = FlxG.height - base.height;
		_hud.add(base);

		_totalText = new FlxText(0, 0);
		_totalText.text = "0";
		_totalText.y = FlxG.height - base.height;
		_totalText.setBorderStyle(OUTLINE, FlxColor.RED, 1);
		_hud.add(_totalText);

		//sprite onde serão desenhadas as linhas ligando os recursos aos predios
		_lines = new FlxSprite(0,0);
		_lines.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		_hud.add(_lines);

		//gera 10 predios randomicamente
		GerentePredio.gerarRandom(quantidadePredios, FlxG.width, Std.int(FlxG.height - base.height) );//para que não aparece ninguem escondino no hud

		//coloca os sprites dos predios nos locais corretos
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
		if(_play)
		{
			_geracao += 1;
			populacao = AlgoritmoGenetico.evoluir(populacao);
			update_lines_recursos();
		}
		super.update(elapsed);

	}

	public function iniciar():Void{

		//deixa na tela a quantidade certa de sprites de _recursos
		// se não tiver nenhum adiciona
		var diff:Int = _recursos.length - quantidadeRecursos;

		if(diff > 0 ){
			for(i in 0...diff){
				_recursos.members.pop();
			}
		}else if(diff < 0){
			diff *= -1;
			for(i in 0...diff){
				//posiciona novos recursos fora da tela
				var r:FlxSprite = new FlxSprite(-10, -10);
				r.makeGraphic(8, 8, FlxColor.YELLOW);
				_recursos.add(r);
			}
		}
		// se for 0 não precisa fazer nada porque
		// ja tem a quantidade certa de recursos na tela

		//gera a população inicial randomica
		populacao = new Populacao(quantidadeRecursos);
		populacao.gerarRandom(quantidadeIndividuos);

		//desenha as rotas dos predios ate o guarda mais proximo
		update_lines_recursos();
	}

	//chama a evolução do algoritmo genetico
	public function evoluir():Void{
		populacao = AlgoritmoGenetico.evoluir(populacao);
	}

	//atualiza os texto de distancia quanto é clicado em um determinado predio
	public function update_text(){
		_predios.forEach( function ( p:PredioSprite ) : Void {
			p.label.text = "" + Std.int(GerentePredio.distancia(id_predio_atual, p.predio_id));
		});
	}

	//atualizar linha conectando os guardas aos predios
	public function update_lines_recursos(){

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
		trace("quantidade:"+res.length);
		for(i in 0...quantidadeRecursos){
			_recursos.members[i].x = res[i].x - (_recursos.members[i].width/2);
			_recursos.members[i].y = res[i].y - (_recursos.members[i].height/2);
		}

		//atualiza melhor distancia
		_totalText.text = "DISTANCIA MEDIA:" + populacao.get_fittest().get_distancia() + " GERAÇÃO: "+ _geracao;

	}

}
