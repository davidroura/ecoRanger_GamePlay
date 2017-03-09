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
			if((Engine.engine.getGameAttribute("playerDistance") == 100))
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
		_customEvent_spawnLife();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_ramdomBlock():Void
	{
		_ramdomX = asNumber(randomInt(Math.floor(-50), Math.floor(50)));
		propertyChanged("_ramdomX", _ramdomX);
		_xobstacle = asNumber((_xobstacle + _ramdomX));
		propertyChanged("_xobstacle", _xobstacle);
		if((_difficulty > randomInt(Math.floor(1), Math.floor(1))))
		{
			sayToScene("spawnHandlerBlock", "_customBlock_dropTrash", [_xobstacle, -5]);
		}
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
			_xobstacle = asNumber(100);
			propertyChanged("_xobstacle", _xobstacle);
		}
		else if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.50))
		{
			_xTree = asNumber(-85);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
			_xTree = asNumber(275);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
			_xobstacle = asNumber(200);
			propertyChanged("_xobstacle", _xobstacle);
		}
		else if((Engine.engine.getGameAttribute("ramdomUniversalNumber") < 0.75))
		{
			_xTree = asNumber(-165);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
			_xTree = asNumber(165);
			propertyChanged("_xTree", _xTree);
			_customEvent_dropTree();
			_xobstacle = asNumber(150);
			propertyChanged("_xobstacle", _xobstacle);
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
			_xobstacle = asNumber(100);
			propertyChanged("_xobstacle", _xobstacle);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_spawnLife():Void
	{
		if((_difficulty < randomInt(Math.floor(35), Math.floor(200))))
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
		getLastCreatedActor().setY(-5);
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
		createRecycledActorOnLayer(getActorType(10), _xobstacle, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(_yobstacle);
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
	public function _customEvent_dropMud():Void
	{
		createRecycledActorOnLayer(getActorType(145), _xobstacle, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(_yobstacle);
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
		nameMap.set("difficulty", "_difficulty");
		_difficulty = 0;
		nameMap.set("ramdomX", "_ramdomX");
		_ramdomX = 0;
		
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