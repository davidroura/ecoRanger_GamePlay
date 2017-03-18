package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;
import box2D.collision.shapes.B2Shape;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_128_128_spawnHandlerBlock extends SceneScript
{
	public var _distanceTree:Float;
	public var _distanceBlock:Float;
	public var _xTree:Float;
	public var _xLife:Float;
	public var _yLife:Float;
	public var _lifehold:Float;
	public var _xobstacle:Float;
	public var _yobstacle:Float;
	public var _bonusCard:Bool;
	public var _ramdomBlockNumber:Float;
	public var _itemNumber:Float;
	public var _temporalVar:String;
	public var _difficulty:Float;
	public var _ramdomX:Float;
	public var _trashHold:Bool;
	public var _treeLeve1:Float;
	public var _treeDificulty:Float;
	public var _treeLevel2:Float;
	public var _treeLevel3:Float;
	public var _trashHolTime:Float;
	public var _obstacleDifficulty:Float;
	public var _obstacleLevel1:Float;
	public var _obstacleLevel2:Float;
	public var _obstacleLevel3:Float;
	public var _marginLeft:Float;
	public var _marginRight:Float;
	public var _obstacleLevel4:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_play():Void
	{
		if((!(_distanceBlock == Engine.engine.getGameAttribute("playerDistance")) && ((Engine.engine.getGameAttribute("playerDistance") % 10) == 0)))
		{
			_ramdomBlockNumber = asNumber(randomFloat());
			propertyChanged("_ramdomBlockNumber", _ramdomBlockNumber);
			if(((Engine.engine.getGameAttribute("playerDistance") % 50) == 0))
			{
				_customEvent_50mts();
			}
			if((Engine.engine.getGameAttribute("playerDistance") == Engine.engine.getGameAttribute("distanceHighScore")))
			{
				if(!(_bonusCard))
				{
					_customEvent_dropBonusCard();
				}
			}
			_customEvent_10mts();
			_distanceBlock = asNumber(Engine.engine.getGameAttribute("playerDistance"));
			propertyChanged("_distanceBlock", _distanceBlock);
			_difficulty = asNumber((_difficulty + 1));
			propertyChanged("_difficulty", _difficulty);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_10mts():Void
	{
		_customEvent_ramdomBlock();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_50mts():Void
	{
		_customEvent_spawnTrees();
		if((2 < randomInt(Math.floor(1), Math.floor(6))))
		{
			_customEvent_spawnLife();
		}
		_obstacleDifficulty = asNumber(randomInt(Math.floor(0), Math.floor((Engine.engine.getGameAttribute("playerDistance") + 10))));
		propertyChanged("_obstacleDifficulty", _obstacleDifficulty);
		if((_obstacleDifficulty < _obstacleLevel1))
		{
			sayToScene("spawnHandlerBlock", "_customBlock_dropMud", [randomInt(Math.floor(50), Math.floor(250)), -100]);
		}
		else if((_obstacleDifficulty < _obstacleLevel2))
		{
			sayToScene("spawnHandlerBlock", "_customBlock_dropRock", [randomInt(Math.floor(50), Math.floor(250)), -50]);
		}
		else if((_obstacleDifficulty < _obstacleLevel3))
		{
			sayToScene("spawnHandlerBlock", "_customBlock_dropMud", [randomInt(Math.floor(50), Math.floor(180)), -10]);
			sayToScene("spawnHandlerBlock", "_customBlock_dropRock", [randomInt(Math.floor(130), Math.floor(250)), -160]);
		}
		else if((_obstacleDifficulty < _obstacleLevel4))
		{
			_yobstacle = asNumber(-10);
			propertyChanged("_yobstacle", _yobstacle);
			for(index0 in 0...Std.int(randomInt(Math.floor(1), Math.floor(3))))
			{
				sayToScene("spawnHandlerBlock", "_customBlock_dropMud", [randomInt(Math.floor(50), Math.floor(250)), _yobstacle]);
				_yobstacle = asNumber((_yobstacle - 100));
				propertyChanged("_yobstacle", _yobstacle);
				sayToScene("spawnHandlerBlock", "_customBlock_dropRock", [randomInt(Math.floor(50), Math.floor(250)), _yobstacle]);
				_yobstacle = asNumber((_yobstacle - 100));
				propertyChanged("_yobstacle", _yobstacle);
			}
		}
		else
		{
			sayToScene("spawnHandlerBlock", "_customBlock_dropBridge", [(_marginLeft + 20), -50]);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_ramdomBlock():Void
	{
		_ramdomX = asNumber(randomInt(Math.floor(-50), Math.floor(50)));
		propertyChanged("_ramdomX", _ramdomX);
		_xobstacle = asNumber((_xobstacle + _ramdomX));
		propertyChanged("_xobstacle", _xobstacle);
		if(!(_trashHold))
		{
			sayToScene("spawnHandlerBlock", "_customBlock_dropTrash", [_xobstacle, -5]);
			if((_difficulty > randomInt(Math.floor(1), Math.floor(500))))
			{
				_trashHold = true;
				propertyChanged("_trashHold", _trashHold);
				runLater(1000 * _trashHolTime, function(timeTask:TimedTask):Void
				{
					_trashHold = false;
					propertyChanged("_trashHold", _trashHold);
				}, null);
			}
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_spawnTrees():Void
	{
		_treeDificulty = asNumber(randomInt(Math.floor(0), Math.floor((Engine.engine.getGameAttribute("playerDistance") + 10))));
		propertyChanged("_treeDificulty", _treeDificulty);
		if((_treeDificulty < _treeLeve1))
		{
			_xTree = asNumber(randomInt(Math.floor(-200), Math.floor(-100)));
			propertyChanged("_xTree", _xTree);
			sayToScene("spawnHandlerBlock", "_customBlock_dropTree", [_xTree, -600]);
			_marginLeft = asNumber((getLastCreatedActor().getX() + 0));
			propertyChanged("_marginLeft", _marginLeft);
			sayToScene("spawnHandlerBlock", "_customBlock_dropTree", [(_xTree + 350), -600]);
			_marginRight = asNumber(getLastCreatedActor().getX());
			propertyChanged("_marginRight", _marginRight);
		}
		else if((_treeDificulty < _treeLevel2))
		{
			_xTree = asNumber(randomInt(Math.floor(-200), Math.floor(-100)));
			propertyChanged("_xTree", _xTree);
			sayToScene("spawnHandlerBlock", "_customBlock_dropTree", [_xTree, -600]);
			_marginLeft = asNumber((getLastCreatedActor().getX() + 0));
			propertyChanged("_marginLeft", _marginLeft);
			sayToScene("spawnHandlerBlock", "_customBlock_dropTree", [(_xTree + 400), -600]);
			_marginRight = asNumber(getLastCreatedActor().getX());
			propertyChanged("_marginRight", _marginRight);
		}
		else if((_treeDificulty < _treeLevel3))
		{
			_xTree = asNumber(randomInt(Math.floor(-150), Math.floor(80)));
			propertyChanged("_xTree", _xTree);
			sayToScene("spawnHandlerBlock", "_customBlock_dropTree", [_xTree, -600]);
			_marginLeft = asNumber((getLastCreatedActor().getX() + 0));
			propertyChanged("_marginLeft", _marginLeft);
			sayToScene("spawnHandlerBlock", "_customBlock_dropTree", [(_xTree + 400), -600]);
			_marginRight = asNumber(getLastCreatedActor().getX());
			propertyChanged("_marginRight", _marginRight);
		}
		else
		{
			_xTree = asNumber(randomInt(Math.floor(-150), Math.floor(80)));
			propertyChanged("_xTree", _xTree);
			sayToScene("spawnHandlerBlock", "_customBlock_dropTree", [_xTree, -600]);
			_marginLeft = asNumber((getLastCreatedActor().getX() + 0));
			propertyChanged("_marginLeft", _marginLeft);
			sayToScene("spawnHandlerBlock", "_customBlock_dropTree", [(_xTree + 200), -600]);
			_marginRight = asNumber(getLastCreatedActor().getX());
			propertyChanged("_marginRight", _marginRight);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_spawnLife():Void
	{
		if((_difficulty < randomInt(Math.floor(35), Math.floor(Engine.engine.getGameAttribute("distanceHighScore")))))
		{
			sayToScene("spawnHandlerBlock", "_customBlock_dropLife", [(_xobstacle + randomInt(Math.floor(-50), Math.floor(50))), -5]);
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_dropRock(__x:Float, __y:Float):Void
	{
		createRecycledActorOnLayer(getActorType(12), __x, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(__y);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_dropTrash(__x:Float, __y:Float):Void
	{
		_ramdomBlockNumber = asNumber(randomInt(Math.floor(1), Math.floor(3)));
		propertyChanged("_ramdomBlockNumber", _ramdomBlockNumber);
		if((_ramdomBlockNumber == 1))
		{
			createRecycledActorOnLayer(getActorType(15), __x, -5, 1, "" + "gamePlay");
			getLastCreatedActor().setAnimation("" + ("" + randomInt(Math.floor(1), Math.floor(4))));
		}
		else if((_ramdomBlockNumber == 2))
		{
			createRecycledActorOnLayer(getActorType(8), __x, -5, 1, "" + "gamePlay");
			getLastCreatedActor().setAnimation("" + ("" + randomInt(Math.floor(1), Math.floor(3))));
		}
		else
		{
			createRecycledActorOnLayer(getActorType(104), __x, -5, 1, "" + "gamePlay");
		}
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(__y);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_dropLife(__x:Float, __y:Float):Void
	{
		createRecycledActorOnLayer(getActorType(10), __x, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(__y);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_dropMud(__x:Float, __y:Float):Void
	{
		createRecycledActorOnLayer(getActorType(145), __x, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(__y);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_dropBridge(__x:Float, __y:Float):Void
	{
		createRecycledActorOnLayer(getActorType(72), __x, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(__y);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_dropTree(__x:Float, __y:Float):Void
	{
		createRecycledActorOnLayer(getActorType(70), __x, 0, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().setY(__y);
		_customEvent_treeType();
		_xobstacle = asNumber((__x + 10));
		propertyChanged("_xobstacle", _xobstacle);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropBonusCard():Void
	{
		createRecycledActor(getActorType(74), 100, -5, Script.FRONT);
		getLastCreatedActor().makeAlwaysSimulate();
		_bonusCard = true;
		propertyChanged("_bonusCard", _bonusCard);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_treeType():Void
	{
		getLastCreatedActor().setAnimation("" + ("" + Math.round((_ramdomBlockNumber * 4))));
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("distanceTree", "_distanceTree");
		_distanceTree = 0.0;
		nameMap.set("distanceBlock", "_distanceBlock");
		_distanceBlock = 0.0;
		nameMap.set("xTree", "_xTree");
		_xTree = 0.0;
		nameMap.set("xLife", "_xLife");
		_xLife = 0.0;
		nameMap.set("yLife", "_yLife");
		_yLife = 0.0;
		nameMap.set("lifehold", "_lifehold");
		_lifehold = 0.0;
		nameMap.set("xobstacle", "_xobstacle");
		_xobstacle = 0.0;
		nameMap.set("yobstacle", "_yobstacle");
		_yobstacle = 0.0;
		nameMap.set("bonusCard", "_bonusCard");
		_bonusCard = false;
		nameMap.set("ramdomBlockNumber", "_ramdomBlockNumber");
		_ramdomBlockNumber = 0.0;
		nameMap.set("itemNumber", "_itemNumber");
		_itemNumber = 0.0;
		nameMap.set("temporalVar", "_temporalVar");
		_temporalVar = "";
		nameMap.set("difficulty", "_difficulty");
		_difficulty = 0.0;
		nameMap.set("ramdomX", "_ramdomX");
		_ramdomX = 0.0;
		nameMap.set("trashHold", "_trashHold");
		_trashHold = false;
		nameMap.set("treeLeve1", "_treeLeve1");
		_treeLeve1 = 0.0;
		nameMap.set("treeDificulty", "_treeDificulty");
		_treeDificulty = 0.0;
		nameMap.set("treeLevel2", "_treeLevel2");
		_treeLevel2 = 0.0;
		nameMap.set("treeLevel3", "_treeLevel3");
		_treeLevel3 = 0.0;
		nameMap.set("trashHolTime", "_trashHolTime");
		_trashHolTime = 0.0;
		nameMap.set("obstacleDifficulty", "_obstacleDifficulty");
		_obstacleDifficulty = 0.0;
		nameMap.set("obstacleLevel1", "_obstacleLevel1");
		_obstacleLevel1 = 0.0;
		nameMap.set("obstacleLevel2", "_obstacleLevel2");
		_obstacleLevel2 = 0.0;
		nameMap.set("obstacleLevel3", "_obstacleLevel3");
		_obstacleLevel3 = 0.0;
		nameMap.set("marginLeft", "_marginLeft");
		_marginLeft = 0;
		nameMap.set("marginRight", "_marginRight");
		_marginRight = 0;
		nameMap.set("obstacleLevel4", "_obstacleLevel4");
		_obstacleLevel4 = 0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_xobstacle = asNumber(100);
		propertyChanged("_xobstacle", _xobstacle);
		_lifehold = asNumber(0);
		propertyChanged("_lifehold", _lifehold);
		_bonusCard = false;
		propertyChanged("_bonusCard", _bonusCard);
		_treeLeve1 = asNumber(200);
		propertyChanged("_treeLeve1", _treeLeve1);
		_treeLevel2 = asNumber(500);
		propertyChanged("_treeLevel2", _treeLevel2);
		_treeLevel3 = asNumber(800);
		propertyChanged("_treeLevel3", _treeLevel3);
		_obstacleLevel1 = asNumber(100);
		propertyChanged("_obstacleLevel1", _obstacleLevel1);
		_obstacleLevel2 = asNumber(200);
		propertyChanged("_obstacleLevel2", _obstacleLevel2);
		_obstacleLevel3 = asNumber(500);
		propertyChanged("_obstacleLevel3", _obstacleLevel3);
		_obstacleLevel4 = asNumber(800);
		propertyChanged("_obstacleLevel4", _obstacleLevel4);
		_trashHolTime = asNumber(1);
		propertyChanged("_trashHolTime", _trashHolTime);
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(190));
				g.drawString("" + _xobstacle, 100, 100);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(Engine.engine.getGameAttribute("game_paused")))
				{
					_customEvent_play();
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}