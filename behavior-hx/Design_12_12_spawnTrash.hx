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
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_doAfter():Void
	{
		_processBusy = true;
		propertyChanged("_processBusy", _processBusy);
		runLater(1000 * randomInt(Math.floor(1), Math.floor(5)), function(timeTask:TimedTask):Void
		{
			_ramdomBlock = asNumber(randomInt(Math.floor(0), Math.floor(2)));
			propertyChanged("_ramdomBlock", _ramdomBlock);
			_customEvent_blockAlign();
		}, null);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_blockAlign():Void
	{
		_ramdomBlockNumber = asNumber(randomInt(Math.floor(1), Math.floor(5)));
		propertyChanged("_ramdomBlockNumber", _ramdomBlockNumber);
		_trashCounter = asNumber(0);
		propertyChanged("_trashCounter", _trashCounter);
		_creatingTrash = true;
		propertyChanged("_creatingTrash", _creatingTrash);
		_trashXPos = asNumber(randomInt(Math.floor(50), Math.floor(250)));
		propertyChanged("_trashXPos", _trashXPos);
		while((_creatingTrash == true))
		{
			_customEvent_dropTrash();
			if((_trashCounter >= _ramdomBlockNumber))
			{
				_creatingTrash = false;
				propertyChanged("_creatingTrash", _creatingTrash);
			}
		}
		_ramdomBlockNumber = asNumber((_ramdomBlockNumber + 1));
		propertyChanged("_ramdomBlockNumber", _ramdomBlockNumber);
		runLater(1000 * (_ramdomBlockNumber * _timeBetweenTrash), function(timeTask:TimedTask):Void
		{
			_processBusy = false;
			propertyChanged("_processBusy", _processBusy);
		}, null);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropTrash():Void
	{
		runLater(1000 * (_trashCounter * _timeBetweenTrash), function(timeTask:TimedTask):Void
		{
			if((_ramdomBlock == 0))
			{
				
			}
			else if((_ramdomBlock == 1))
			{
				_trashXPos = asNumber((_trashXPos + 15));
				propertyChanged("_trashXPos", _trashXPos);
			}
			else if((_ramdomBlock == 2))
			{
				_trashXPos = asNumber((_trashXPos - 15));
				propertyChanged("_trashXPos", _trashXPos);
			}
			_trashType = asNumber(randomInt(Math.floor(1), Math.floor(3)));
			propertyChanged("_trashType", _trashType);
			if((_trashType == 1))
			{
				createRecycledActorOnLayer(getActorType(8), _trashXPos, -5, 1, "" + "gamePlay");
				getLastCreatedActor().growTo(70/100, 70/100, 0, Linear.easeNone);
			}
			else if((_trashType == 2))
			{
				createRecycledActorOnLayer(getActorType(104), _trashXPos, -5, 1, "" + "gamePlay");
				getLastCreatedActor().growTo(30/100, 30/100, 0, Linear.easeNone);
			}
			else
			{
				createRecycledActorOnLayer(getActorType(15), _trashXPos, -5, 1, "" + "gamePlay");
				getLastCreatedActor().growTo(70/100, 70/100, 0, Linear.easeNone);
			}
		}, null);
		_trashCounter = asNumber((_trashCounter + 1));
		propertyChanged("_trashCounter", _trashCounter);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_timeCount():Void
	{
		_frameCount = asNumber((_frameCount + 1));
		propertyChanged("_frameCount", _frameCount);
		if((_frameCount > _frameRate))
		{
			_time = asNumber((_time + 1));
			propertyChanged("_time", _time);
			_frameCount = asNumber(0);
			propertyChanged("_frameCount", _frameCount);
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
		_timeBetweenTrash = asNumber(0.3);
		propertyChanged("_timeBetweenTrash", _timeBetweenTrash);
		_customEvent_doAfter();
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_customEvent_timeCount();
				if(!(_processBusy))
				{
					_customEvent_doAfter();
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}