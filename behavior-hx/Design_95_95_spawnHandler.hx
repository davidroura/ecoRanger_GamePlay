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



class Design_95_95_spawnHandler extends SceneScript
{
	public var _trashType:Float;
	public var _trashXPos:Float;
	public var _trashXPosWidth:Float;
	public var _trashYPos:Float;
	public var _dot1X:Float;
	public var _dot1Y:Float;
	public var _a:Float;
	public var _treeAnimation:Float;
	public var _distanceObstacle:Float;
	public var _distanceLife:Float;
	public var _distanceTrash:Float;
	public var _distanceTree:Float;
	public var _parabolaRight:Array<Dynamic>;
	public var _xyDots:Array<Dynamic>;
	public var _ramdomNumber012:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_contiousSpawn():Void
	{
		if((!(_distanceTree == Engine.engine.getGameAttribute("playerDistance")) && ((Engine.engine.getGameAttribute("playerDistance") % 50) == 0)))
		{
			_customEvent_treeSpawn();
			_distanceTree = asNumber(Engine.engine.getGameAttribute("playerDistance"));
			propertyChanged("_distanceTree", _distanceTree);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_ocasionalSpawn():Void
	{
		if((!(_distanceTrash == Engine.engine.getGameAttribute("playerDistance")) && ((Engine.engine.getGameAttribute("playerDistance") % 70) == 0)))
		{
			_customEvent_trashSpawn();
			_distanceTrash = asNumber(Engine.engine.getGameAttribute("playerDistance"));
			propertyChanged("_distanceTrash", _distanceTrash);
		}
		if((!(_distanceLife == Engine.engine.getGameAttribute("playerDistance")) && ((Engine.engine.getGameAttribute("playerDistance") % 50) == 0)))
		{
			_customEvent_lifeSpawn();
			_distanceLife = asNumber(Engine.engine.getGameAttribute("playerDistance"));
			propertyChanged("_distanceLife", _distanceLife);
		}
		if((!(_distanceObstacle == Engine.engine.getGameAttribute("playerDistance")) && ((Engine.engine.getGameAttribute("playerDistance") % 110) == 0)))
		{
			_customEvent_ObstacleRamdomSpaw();
			_distanceObstacle = asNumber(Engine.engine.getGameAttribute("playerDistance"));
			propertyChanged("_distanceObstacle", _distanceObstacle);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_trashSpawn():Void
	{
		_a = asNumber(0);
		propertyChanged("_a", _a);
		_customEvent_trashListSpawn();
		_a = asNumber(1);
		propertyChanged("_a", _a);
		_customEvent_trashListSpawn();
		_a = asNumber(2);
		propertyChanged("_a", _a);
		_customEvent_trashListSpawn();
		_a = asNumber(3);
		propertyChanged("_a", _a);
		_customEvent_trashListSpawn();
		_a = asNumber(4);
		propertyChanged("_a", _a);
		_customEvent_trashListSpawn();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_trashListSpawn():Void
	{
		_customEvent_trashRamdomItem();
		_dot1X = asNumber(_parabolaRight[Std.int(0)][Std.int(_a)]);
		propertyChanged("_dot1X", _dot1X);
		_dot1Y = asNumber(_parabolaRight[Std.int(1)][Std.int(_a)]);
		propertyChanged("_dot1Y", _dot1Y);
		getLastCreatedActor().setX(((_dot1X * 20) + 50));
		getLastCreatedActor().setY(((-(_dot1Y) * 20) - 5));
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_trashRamdomItem():Void
	{
		/* 0) bottle
1) can
2) plastic */
		if((_ramdomNumber012 > 9))
		{
			createRecycledActorOnLayer(getActorType(8), 0, -5, 1, "" + "gamePlay");
			getLastCreatedActor().growTo(50/100, 50/100, 0, Linear.easeNone);
		}
		else if((_ramdomNumber012 > 6))
		{
			createRecycledActorOnLayer(getActorType(15), 0, -5, 1, "" + "gamePlay");
			getLastCreatedActor().growTo(50/100, 50/100, 0, Linear.easeNone);
		}
		else
		{
			createRecycledActorOnLayer(getActorType(104), 0, -5, 1, "" + "gamePlay");
			getLastCreatedActor().growTo(20/100, 20/100, 0, Linear.easeNone);
		}
		getLastCreatedActor().makeAlwaysSimulate();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_lifeSpawn():Void
	{
		createRecycledActorOnLayer(getActorType(10), randomInt(Math.floor(50), Math.floor(280)), -5, 1, "" + "gamePlay");
		getLastCreatedActor().growTo(70/100, 70/100, 0, Linear.easeNone);
		Engine.engine.setGameAttribute("spawnLife", false);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_treeSpawn():Void
	{
		createRecycledActorOnLayer(getActorType(70), -120, 0, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().setY(-600);
		_customEvent_treeType();
		createRecycledActorOnLayer(getActorType(70), 220, 0, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().setY(-600);
		_customEvent_treeType();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_treeType():Void
	{
		getLastCreatedActor().growTo(100/100, 100/100, 0, Linear.easeNone);
		_treeAnimation = asNumber(randomInt(Math.floor(1), Math.floor(2)));
		propertyChanged("_treeAnimation", _treeAnimation);
		if((_ramdomNumber012 < 6))
		{
			getLastCreatedActor().setAnimation("" + "tree1");
		}
		else
		{
			getLastCreatedActor().setAnimation("" + "tree2");
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_ObstacleRamdomSpaw():Void
	{
		if((_ramdomNumber012 < 6))
		{
			_customEvent_ObstacleRock();
		}
		else
		{
			_customEvent_ObstacleRamdomBridge();
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_ObstacleRock():Void
	{
		createRecycledActorOnLayer(getActorType(12), randomInt(Math.floor(50), Math.floor(260)), -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().growTo(70/100, 70/100, 0, Linear.easeNone);
		getLastCreatedActor().setY(-20);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_ObstacleRamdomBridge():Void
	{
		createRecycledActorOnLayer(getActorType(72), 0, -5, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().moveToBottom();
		getLastCreatedActor().setY(-50);
		if((6 < _ramdomNumber012))
		{
			getLastCreatedActor().setAnimation("" + "left");
		}
		else
		{
			getLastCreatedActor().setAnimation("" + "right");
		}
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("trashType", "_trashType");
		_trashType = 0.0;
		nameMap.set("trashXPos", "_trashXPos");
		_trashXPos = 0.0;
		nameMap.set("trashXPosWidth", "_trashXPosWidth");
		_trashXPosWidth = 0.0;
		nameMap.set("trashYPos", "_trashYPos");
		_trashYPos = 0.0;
		nameMap.set("dot1X", "_dot1X");
		_dot1X = 0.0;
		nameMap.set("dot1Y", "_dot1Y");
		_dot1Y = 0.0;
		nameMap.set("a", "_a");
		_a = 0.0;
		nameMap.set("treeAnimation", "_treeAnimation");
		_treeAnimation = 0.0;
		nameMap.set("distanceObstacle", "_distanceObstacle");
		_distanceObstacle = 0.0;
		nameMap.set("distanceLife", "_distanceLife");
		_distanceLife = 0.0;
		nameMap.set("distanceTrash", "_distanceTrash");
		_distanceTrash = 0.0;
		nameMap.set("distanceTree", "_distanceTree");
		_distanceTree = 0.0;
		nameMap.set("parabolaRight", "_parabolaRight");
		_parabolaRight = [];
		nameMap.set("xyDots", "_xyDots");
		_xyDots = [];
		nameMap.set("ramdomNumber012", "_ramdomNumber012");
		_ramdomNumber012 = 0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		/* crear una lista con los puntos de cada parabola que luego se podran mover */
		_parabolaRight = new Array<Dynamic>();
		propertyChanged("_parabolaRight", _parabolaRight);
		_xyDots = new Array<Dynamic>();
		propertyChanged("_xyDots", _xyDots);
		_xyDots.push(0);
		_xyDots.push(0);
		_parabolaRight.push(_xyDots);
		_xyDots = new Array<Dynamic>();
		propertyChanged("_xyDots", _xyDots);
		_xyDots.push(1);
		_xyDots.push(1.73);
		_parabolaRight.push(_xyDots);
		_xyDots = new Array<Dynamic>();
		propertyChanged("_xyDots", _xyDots);
		_xyDots.push(2);
		_xyDots.push(3);
		_parabolaRight.push(_xyDots);
		_xyDots = new Array<Dynamic>();
		propertyChanged("_xyDots", _xyDots);
		_xyDots.push(3);
		_xyDots.push(3.88);
		_parabolaRight.push(_xyDots);
		_xyDots = new Array<Dynamic>();
		propertyChanged("_xyDots", _xyDots);
		_xyDots.push(4);
		_xyDots.push(4.1);
		_parabolaRight.push(_xyDots);
		_xyDots = new Array<Dynamic>();
		propertyChanged("_xyDots", _xyDots);
		_xyDots.push(5);
		_xyDots.push(4);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				/* Here we set how stuff spawn,  */
				_ramdomNumber012 = asNumber(randomInt(Math.floor(0), Math.floor(12)));
				propertyChanged("_ramdomNumber012", _ramdomNumber012);
				if((Engine.engine.getGameAttribute("playerHealth") > 3))
				{
					_customEvent_contiousSpawn();
					_customEvent_ocasionalSpawn();
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}