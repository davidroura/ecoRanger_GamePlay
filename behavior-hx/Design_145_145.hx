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



class Design_145_145 extends SceneScript
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
	public var _trashType:Float;
	public var _trashPos:Float;
	public var _spawnWait:Bool;
	public var _lifeWait:Bool;
	public var _itemRange:Float;
	public var _itemRangeMin:Float;
	public var _nextDropObstacle:Float;
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_dropObstacle(__difficulty:Float):Void
	{
		_trashType = asNumber(randomInt(Math.floor(0), Math.floor(1)));
		propertyChanged("_trashType", _trashType);
		if((Engine.engine.getGameAttribute("playerDistance") >= _nextDropObstacle))
		{
			trace("" + (("" + "Difficulty ") + ("" + "")));
			if(((_trashType == 0) && (__difficulty > randomInt(Math.floor(0), Math.floor(20)))))
			{
				_customEvent_dropRock();
			}
			if(((_trashType == 1) && (__difficulty > randomInt(Math.floor(-5), Math.floor(10)))))
			{
				_customEvent_dropMud();
			}
			_spawnWait = false;
			propertyChanged("_spawnWait", _spawnWait);
			_nextDropObstacle = asNumber((Engine.engine.getGameAttribute("playerDistance") + (randomInt(Math.floor(200), Math.floor(400)) / __difficulty)));
			propertyChanged("_nextDropObstacle", _nextDropObstacle);
			trace("" + (("" + "next obstacle ") + ("" + _nextDropObstacle)));
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropRock():Void
	{
		trace("" + "rock Dropped");
		createRecycledActorOnLayer(getActorType(12), randomInt(Math.floor(_itemRangeMin), Math.floor(_itemRange)), -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropMud():Void
	{
		trace("" + "mud Dropped");
		createRecycledActorOnLayer(getActorType(145), randomInt(Math.floor(_itemRangeMin), Math.floor(_itemRange)), -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_droplife():Void
	{
		trace("" + "life Dropped");
		createRecycledActorOnLayer(getActorType(10), randomInt(Math.floor(_itemRangeMin), Math.floor(_itemRange)), -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_blockOne():Void
	{
		/* ramdomUniversalNumber
0.25 => Center
0.50 => Right
0.75 => Left
otherwise => sides */
		_customEvent_spawnTrees();
		if((Engine.engine.getGameAttribute("playerDistance") < 1000))
		{
			_customEvent_level1();
		}
		else
		{
			_customEvent_level2();
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_level1():Void
	{
		if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.25))
		{
			_temporalVar = "1";
			propertyChanged("_temporalVar", _temporalVar);
			sayToScene("spawnHandlerBlock", "_customBlock_spawnTrashRamdom", [_ramdomBlockNumber, 100, -30]);
			sayToScene("spawnHandlerBlock", "_customBlock_spawnTrashRamdom", [(Engine.engine.getGameAttribute("ramdomUniversalNumber") * 4), 200, -120]);
		}
		else if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.50))
		{
			sayToScene("spawnHandlerBlock", "_customBlock_spawnTrashRamdom", [0.5, (_ramdomBlockNumber * 120), -(((_ramdomBlockNumber * 900) + 10))]);
		}
		else if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.75))
		{
			_temporalVar = "3";
			propertyChanged("_temporalVar", _temporalVar);
			sayToScene("spawnHandlerBlock", "_customBlock_spawnTrashRamdom", [_ramdomBlockNumber, ((Engine.engine.getGameAttribute("ramdomUniversalNumber") * 120) + 80), -30]);
		}
		else
		{
			_temporalVar = "4";
			propertyChanged("_temporalVar", _temporalVar);
			sayToScene("spawnHandlerBlock", "_customBlock_spawnTrashRamdom", [_ramdomBlockNumber, ((Engine.engine.getGameAttribute("ramdomUniversalNumber") * 120) + 80), -30]);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_level2():Void
	{
		
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
	public function _customEvent_spawnTrash():Void
	{
		_xobstacle = asNumber((_xobstacle + 20));
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_spawnTrashRamdom(__orientation:Float, __xPosition:Float, __yPosition:Float):Void
	{
		_xobstacle = asNumber(__xPosition);
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber(__yPosition);
		propertyChanged("_yobstacle", _yobstacle);
		for(index0 in 0...Std.int(4))
		{
			if((__orientation < 0.33))
			{
				_xobstacle = asNumber((_xobstacle + 20));
				propertyChanged("_xobstacle", _xobstacle);
			}
			else if((__orientation < 0.66))
			{
				_xobstacle = asNumber((_xobstacle - 20));
				propertyChanged("_xobstacle", _xobstacle);
			}
			_yobstacle = asNumber((_yobstacle - 20));
			propertyChanged("_yobstacle", _yobstacle);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_spawnTrashLeft():Void
	{
		_xobstacle = asNumber((_xobstacle - 20));
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
		_xobstacle = asNumber((_xobstacle - 20));
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
		_xobstacle = asNumber((_xobstacle - 20));
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
		_xobstacle = asNumber((_xobstacle - 20));
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_spawnTrashRight():Void
	{
		_xobstacle = asNumber((_xobstacle + 20));
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
		_xobstacle = asNumber((_xobstacle + 20));
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
		_xobstacle = asNumber((_xobstacle + 20));
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
		_xobstacle = asNumber((_xobstacle + 20));
		propertyChanged("_xobstacle", _xobstacle);
		_yobstacle = asNumber((_yobstacle - 20));
		propertyChanged("_yobstacle", _yobstacle);
		_customEvent_dropTrash();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_spawnLife():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropTree():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropTrash():Void
	{
		_ramdomBlockNumber = asNumber(randomInt(Math.floor(1), Math.floor(3)));
		propertyChanged("_ramdomBlockNumber", _ramdomBlockNumber);
		if((_ramdomBlockNumber == 1))
		{
			createRecycledActorOnLayer(getActorType(15), _xobstacle, -5, 1, "" + "gamePlay");
			_itemNumber = asNumber(4);
			propertyChanged("_itemNumber", _itemNumber);
		}
		else if((_ramdomBlockNumber == 2))
		{
			createRecycledActorOnLayer(getActorType(8), _xobstacle, -5, 1, "" + "gamePlay");
			_itemNumber = asNumber(2);
			propertyChanged("_itemNumber", _itemNumber);
		}
		else
		{
			createRecycledActorOnLayer(getActorType(104), _xobstacle, -5, 1, "" + "gamePlay");
			_itemNumber = asNumber(3);
			propertyChanged("_itemNumber", _itemNumber);
		}
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(_yobstacle);
		getLastCreatedActor().setAnimation("" + ("" + ("" + Math.round((Engine.engine.getGameAttribute("ramdomUniversalNumber") * _itemNumber)))));
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropBridge():Void
	{
		createRecycledActorOnLayer(getActorType(72), 0, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(_yobstacle);
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
		nameMap.set("trashType", "_trashType");
		_trashType = 0.0;
		nameMap.set("trashPos", "_trashPos");
		_trashPos = 0.0;
		nameMap.set("spawnWait", "_spawnWait");
		_spawnWait = false;
		nameMap.set("lifeWait", "_lifeWait");
		_lifeWait = false;
		nameMap.set("itemRange", "_itemRange");
		_itemRange = 300;
		nameMap.set("itemRangeMin", "_itemRangeMin");
		_itemRangeMin = 50;
		nameMap.set("nextDropObstacle", "_nextDropObstacle");
		_nextDropObstacle = 0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_lifehold = asNumber(0);
		propertyChanged("_lifehold", _lifehold);
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(190));
				g.drawString("" + _temporalVar, 100, 100);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((!(Engine.engine.getGameAttribute("game_paused")) && !(_spawnWait)))
				{
					_ramdomBlockNumber = asNumber(randomFloat());
					propertyChanged("_ramdomBlockNumber", _ramdomBlockNumber);
					_spawnWait = true;
					propertyChanged("_spawnWait", _spawnWait);
					_distanceBlock = asNumber(Engine.engine.getGameAttribute("playerDistance"));
					propertyChanged("_distanceBlock", _distanceBlock);
				}
				if(!(_lifeWait))
				{
					_lifeWait = true;
					propertyChanged("_lifeWait", _lifeWait);
					runLater(1000 * randomFloatBetween(1.8, 3.3), function(timeTask:TimedTask):Void
					{
						_customEvent_droplife();
						_lifeWait = false;
						propertyChanged("_lifeWait", _lifeWait);
					}, null);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}