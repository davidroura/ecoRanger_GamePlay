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



class Design_146_146_spawnHandlerBlock2 extends SceneScript
{
	public var _distanceTree:Float;
	public var _distanceBlock:Float;
	public var _xTree:Float;
	public var _xLife:Float;
	public var _xobstacle:Float;
	public var _yobstacle:Float;
	public var _ramdomBlockNumber:Float;
	public var _itemNumber:Float;
	public var _temporalVar:String;
	public var _trashType:Float;
	public var _trashPos:Float;
	public var _spawnWait:Bool;
	public var _lifeWait:Bool;
	public var _itemRange:Float;
	public var _itemRangeMin:Float;
	public var _nextDropObstacle:Float;
	public var _randomInt:Float;
	public var _trashShapes:Array<Dynamic>;
	public var _tempCounter:Float;
	public var _trashPosList:Array<Dynamic>;
	public var _trashWait:Bool;
	public var _trashCurveWidth:Float;
	public var _trashCurveLength:Float;
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_dropTrash():Void
	{
		/* Gets a list of x pos for trash and drop it at intervals */
		_trashCurveLength = asNumber(randomFloatBetween(-.05, .1));
		propertyChanged("_trashCurveLength", _trashCurveLength);
		_trashCurveWidth = asNumber(randomFloatBetween(.7, 2));
		propertyChanged("_trashCurveWidth", _trashCurveWidth);
		_trashPosList = ("" + ("" + _trashShapes[Std.int(randomInt(Math.floor(0), Math.floor(_trashShapes.length)))])).split(",");
		propertyChanged("_trashPosList", _trashPosList);
		runPeriodically(1000 * (.2 + _trashCurveLength), function(timeTask:TimedTask):Void
		{
			/* make drop single trash take an argument for trash type and xpos. use that here */
			createRecycledActor(getActorType(15), (asNumber(_trashPosList[Std.int(_tempCounter)]) * 1), -5, Script.FRONT);
			_tempCounter = asNumber((_tempCounter + 1));
			propertyChanged("_tempCounter", _tempCounter);
			if((_tempCounter == _trashPosList.length))
			{
				_tempCounter = asNumber(0);
				propertyChanged("_tempCounter", _tempCounter);
				timeTask.repeats = false;
				return;
			}
		}, null);
		runLater(1000 * randomInt(Math.floor(3), Math.floor(5)), function(timeTask:TimedTask):Void
		{
			_trashWait = false;
			propertyChanged("_trashWait", _trashWait);
		}, null);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_dropObstacle(__difficulty:Float):Void
	{
		_trashType = asNumber(randomInt(Math.floor(0), Math.floor(2)));
		propertyChanged("_trashType", _trashType);
		if((Engine.engine.getGameAttribute("playerDistance") >= _nextDropObstacle))
		{
			if(((_trashType == 0) && (__difficulty > randomInt(Math.floor(5), Math.floor(25)))))
			{
				trace("" + "drop rock");
				_customEvent_dropRock();
			}
			if(((_trashType == 1) && (__difficulty > randomInt(Math.floor(-10), Math.floor(35)))))
			{
				trace("" + "drop mud");
				_customEvent_dropMud();
			}
			if((_trashType == 2))
			{
				_customEvent_dropSingleTrash();
				trace("" + "dropTrash");
			}
			_nextDropObstacle = asNumber((Engine.engine.getGameAttribute("playerDistance") + (randomInt(Math.floor(150), Math.floor(372)) / (__difficulty + 7))));
			propertyChanged("_nextDropObstacle", _nextDropObstacle);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropSingleTrash():Void
	{
		if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.4))
		{
			createRecycledActor(getActorType(15), randomInt(Math.floor(_itemRangeMin), Math.floor(_itemRange)), -5, Script.FRONT);
		}
		else if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.7))
		{
			createRecycledActor(getActorType(104), randomInt(Math.floor(_itemRangeMin), Math.floor(_itemRange)), -5, Script.FRONT);
		}
		else
		{
			createRecycledActor(getActorType(8), randomInt(Math.floor(_itemRangeMin), Math.floor(_itemRange)), -5, Script.FRONT);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropRock():Void
	{
		_randomInt = asNumber(randomInt(Math.floor(_itemRangeMin), Math.floor(_itemRange)));
		propertyChanged("_randomInt", _randomInt);
		createRecycledActorOnLayer(getActorType(12), _randomInt, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropMud():Void
	{
		_randomInt = asNumber(randomInt(Math.floor(_itemRangeMin), Math.floor(_itemRange)));
		propertyChanged("_randomInt", _randomInt);
		createRecycledActorOnLayer(getActorType(145), _randomInt, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_droplife():Void
	{
		_randomInt = asNumber(randomInt(Math.floor(_itemRangeMin), Math.floor(_itemRange)));
		propertyChanged("_randomInt", _randomInt);
		createRecycledActorOnLayer(getActorType(10), _randomInt, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_spawnTrees():Void
	{
		if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.25))
		{
			_xTree = asNumber(-165);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
			_xTree = asNumber(225);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
		}
		else if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.50))
		{
			_xTree = asNumber(-85);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
			_xTree = asNumber(275);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
		}
		else if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.75))
		{
			_xTree = asNumber(-165);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
			_xTree = asNumber(165);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
		}
		else
		{
			_xTree = asNumber(55);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
			getLastCreatedActor().growTo(50/100, 50/100, 0, Linear.easeNone);
			_xTree = asNumber(-165);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
			_xTree = asNumber(275);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropTree():Void
	{
		createRecycledActorOnLayer(getActorType(70), _xTree, 0, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().setY(-600);
		_customEvent_treeType();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_treeType():Void
	{
		getLastCreatedActor().growTo(100/100, 100/100, 0, Linear.easeNone);
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
		nameMap.set("xobstacle", "_xobstacle");
		_xobstacle = 0.0;
		nameMap.set("yobstacle", "_yobstacle");
		_yobstacle = 0.0;
		nameMap.set("ramdomBlockNumber", "_ramdomBlockNumber");
		_ramdomBlockNumber = 0.0;
		nameMap.set("itemNumber", "_itemNumber");
		_itemNumber = 0.0;
		nameMap.set("temporalVar", "_temporalVar");
		_temporalVar = "";
		nameMap.set("trashType", "_trashType");
		_trashType = 0.0;
		nameMap.set("trashPos", "_trashPos");
		_trashPos = 0.0;
		nameMap.set("spawnWait", "_spawnWait");
		_spawnWait = false;
		nameMap.set("lifeWait", "_lifeWait");
		_lifeWait = false;
		nameMap.set("itemRange", "_itemRange");
		_itemRange = 230.0;
		nameMap.set("itemRangeMin", "_itemRangeMin");
		_itemRangeMin = 50.0;
		nameMap.set("nextDropObstacle", "_nextDropObstacle");
		_nextDropObstacle = 10.0;
		nameMap.set("randomInt", "_randomInt");
		_randomInt = 0.0;
		nameMap.set("trashShapes", "_trashShapes");
		_trashShapes = [];
		nameMap.set("tempCounter", "_tempCounter");
		_tempCounter = 0.0;
		nameMap.set("trashPosList", "_trashPosList");
		_trashPosList = [];
		nameMap.set("trashWait", "_trashWait");
		_trashWait = false;
		nameMap.set("trashCurveWidth", "_trashCurveWidth");
		_trashCurveWidth = 0.0;
		nameMap.set("trashCurveLength", "_trashCurveLength");
		_trashCurveLength = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_trashShapes = new Array<Dynamic>();
		propertyChanged("_trashShapes", _trashShapes);
		/* curve */
		_trashShapes.push("100,135,145,138,120,110,125,145,175");
		/* alternating */
		_trashShapes.push("100,210,100,210,100,210");
		/* top small curve */
		_trashShapes.push("120,130,140,145,150,153,156,158");
		/* straight */
		_trashShapes.push("150,150,150,150,150,150,150,150");
		/* 2's */
		_trashShapes.push("156,150,165,150,165,150,165,150,165,156");
		/* curve */
		_trashShapes.push("120,130,140,150,140,130,120");
		_itemRange = asNumber(250);
		propertyChanged("_itemRange", _itemRange);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(Engine.engine.getGameAttribute("game_paused")))
				{
					sayToScene("spawnHandlerBlock2", "_customBlock_dropObstacle", [Math.ceil((Engine.engine.getGameAttribute("playerDistance") / 200))]);
					if(!(_trashWait))
					{
						_trashWait = true;
						propertyChanged("_trashWait", _trashWait);
						sayToScene("spawnHandlerBlock2", "_customBlock_dropTrash");
					}
					if(!(_lifeWait))
					{
						_lifeWait = true;
						propertyChanged("_lifeWait", _lifeWait);
						runLater(1000 * randomFloatBetween(4, 5.5), function(timeTask:TimedTask):Void
						{
							_customEvent_droplife();
							_lifeWait = false;
							propertyChanged("_lifeWait", _lifeWait);
						}, null);
					}
					if((!(_distanceBlock == Engine.engine.getGameAttribute("playerDistance")) && ((Engine.engine.getGameAttribute("playerDistance") % 50) == 0)))
					{
						trace("" + "drop attempt");
						_distanceBlock = asNumber(Engine.engine.getGameAttribute("playerDistance"));
						propertyChanged("_distanceBlock", _distanceBlock);
						_ramdomBlockNumber = asNumber(randomFloat());
						propertyChanged("_ramdomBlockNumber", _ramdomBlockNumber);
						_customEvent_spawnTrees();
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}