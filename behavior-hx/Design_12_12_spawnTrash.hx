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



class Design_12_12_spawnTrash extends SceneScript
{
	public var _frameRate:Float;
	public var _frameCount:Float;
	public var _time:Float;
	public var _ramdomBlock:Float;
	public var _processBusy:Bool;
	public var _creatingTrash:Bool;
	public var _trashCounter:Float;
	public var _ramdomBlockNumber:Float;
	public var _timeBetweenTrash:Float;
	public var _trashXPos:Float;
	public var _trashType:Float;
	public var _currentDistance:Float;
	public var _trashYPos:Float;
	public var _spawning:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_trashByDistance():Void
	{
		if(((Engine.engine.getGameAttribute("playerDistance") % 100) == 0))
		{
			if(!(_spawning))
			{
				_trashType = asNumber(randomInt(Math.floor(0), Math.floor(1)));
				propertyChanged("_trashType", _trashType);
				_spawning = true;
				propertyChanged("_spawning", _spawning);
				_trashXPos = asNumber(5);
				propertyChanged("_trashXPos", _trashXPos);
				for(index0 in 0...Std.int(5))
				{
					createRecycledActorOnLayer(getActorType(8), 0, -5, 1, "" + "gamePlay");
					getLastCreatedActor().makeAlwaysSimulate();
					if((_trashType == 0))
					{
						_trashYPos = asNumber((Math.pow(_trashXPos, 2) + ((5 * _trashXPos) + 100)));
						propertyChanged("_trashYPos", _trashYPos);
					}
					else
					{
						_trashYPos = asNumber((Math.pow(_trashXPos, 2) - ((5 * _trashXPos) + 100)));
						propertyChanged("_trashYPos", _trashYPos);
					}
					_trashXPos = asNumber((_trashXPos + 5));
					propertyChanged("_trashXPos", _trashXPos);
					getLastCreatedActor().setX(_trashXPos);
					getLastCreatedActor().setY(_trashYPos);
				}
			}
		}
		else
		{
			_spawning = false;
			propertyChanged("_spawning", _spawning);
		}
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("frameRate", "_frameRate");
		_frameRate = 0.0;
		nameMap.set("frameCount", "_frameCount");
		_frameCount = 0.0;
		nameMap.set("time", "_time");
		_time = 0.0;
		nameMap.set("ramdomBlock", "_ramdomBlock");
		_ramdomBlock = 0.0;
		nameMap.set("processBusy", "_processBusy");
		_processBusy = false;
		nameMap.set("creatingTrash", "_creatingTrash");
		_creatingTrash = false;
		nameMap.set("trashCounter", "_trashCounter");
		_trashCounter = 0.0;
		nameMap.set("ramdomBlockNumber", "_ramdomBlockNumber");
		_ramdomBlockNumber = 0.0;
		nameMap.set("timeBetweenTrash", "_timeBetweenTrash");
		_timeBetweenTrash = 0.0;
		nameMap.set("trashXPos", "_trashXPos");
		_trashXPos = 0.0;
		nameMap.set("trashType", "_trashType");
		_trashType = 0.0;
		nameMap.set("currentDistance", "_currentDistance");
		_currentDistance = 0.0;
		nameMap.set("trashYPos", "_trashYPos");
		_trashYPos = 0;
		nameMap.set("spawning", "_spawning");
		_spawning = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_frameRate = asNumber(60);
		propertyChanged("_frameRate", _frameRate);
		_frameCount = asNumber(1);
		propertyChanged("_frameCount", _frameCount);
		_time = asNumber(0);
		propertyChanged("_time", _time);
		_timeBetweenTrash = asNumber(0.2);
		propertyChanged("_timeBetweenTrash", _timeBetweenTrash);
		_trashType = asNumber(randomInt(Math.floor(0), Math.floor(1)));
		propertyChanged("_trashType", _trashType);
		_spawning = false;
		propertyChanged("_spawning", _spawning);
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(135));
				g.drawString("" + ("" + Engine.engine.getGameAttribute("playerDistance")), 100, 100);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(Engine.engine.getGameAttribute("spawnThings"))
				{
					_customEvent_trashByDistance();
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}