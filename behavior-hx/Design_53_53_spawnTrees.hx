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



class Design_53_53_spawnTrees extends SceneScript
{
	public var _frameCount:Float;
	public var _time:Float;
	public var _frameRate:Float;
	public var _spawnTime:Float;
	public var _spanwTimeRight:Float;
	public var _minTime:Float;
	public var _maxTime:Float;
	public var _timeRight:Float;
	public var _treeAnimation:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_timeCount():Void
	{
		_frameCount = asNumber((_frameCount + 1));
		propertyChanged("_frameCount", _frameCount);
		if((_frameCount > _frameRate))
		{
			_time = asNumber((_time + 1));
			propertyChanged("_time", _time);
			_timeRight = asNumber((_timeRight + 1));
			propertyChanged("_timeRight", _timeRight);
			_frameCount = asNumber(0);
			propertyChanged("_frameCount", _frameCount);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_spawnTrees():Void
	{
		createRecycledActorOnLayer(getActorType(70), -120, 0, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().setY(-200);
		_customEvent_treeType();
		createRecycledActorOnLayer(getActorType(70), 220, 0, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().setY(-200);
		_customEvent_treeType();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_leftTrees():Void
	{
		createRecycledActorOnLayer(getActorType(70), -120, 0, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().setY(-200);
		_customEvent_treeType();
		_time = asNumber(0);
		propertyChanged("_time", _time);
		_spawnTime = asNumber(randomInt(Math.floor(_minTime), Math.floor(_maxTime)));
		propertyChanged("_spawnTime", _spawnTime);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_treeType():Void
	{
		getLastCreatedActor().growTo(100/100, 100/100, 0, Linear.easeNone);
		_treeAnimation = asNumber(randomInt(Math.floor(1), Math.floor(2)));
		propertyChanged("_treeAnimation", _treeAnimation);
		if((_treeAnimation == 1))
		{
			getLastCreatedActor().setAnimation("" + "tree1");
		}
		else if((_treeAnimation == 2))
		{
			getLastCreatedActor().setAnimation("" + "tree2");
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_rightTrees():Void
	{
		
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("frameCount", "_frameCount");
		_frameCount = 0.0;
		nameMap.set("time", "_time");
		_time = 0.0;
		nameMap.set("frameRate", "_frameRate");
		_frameRate = 0.0;
		nameMap.set("spawnTime", "_spawnTime");
		_spawnTime = 0.0;
		nameMap.set("spanwTimeRight", "_spanwTimeRight");
		_spanwTimeRight = 0.0;
		nameMap.set("minTime", "_minTime");
		_minTime = 0.0;
		nameMap.set("maxTime", "_maxTime");
		_maxTime = 0.0;
		nameMap.set("timeRight", "_timeRight");
		_timeRight = 0.0;
		nameMap.set("treeAnimation", "_treeAnimation");
		_treeAnimation = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		createRecycledActorOnLayer(getActorType(70), -120, 0, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().setY(-200);
		_customEvent_treeType();
		createRecycledActorOnLayer(getActorType(70), 220, 0, 1, "" + "gamePlay");
		getLastCreatedActor().makeAlwaysSimulate();
		getLastCreatedActor().setY(-200);
		_customEvent_treeType();
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(Engine.engine.getGameAttribute("spawnThings"))
				{
					if((getLastCreatedActor().getY() >= 100))
					{
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