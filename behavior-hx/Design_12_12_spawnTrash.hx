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
	public var _dot1X:Float;
	public var _dot1Y:Float;
	public var _dot2X:Float;
	public var _dot2Y:Float;
	public var _dot3X:Float;
	public var _dot3Y:Float;
	public var _a:Float;
	public var _b:Float;
	public var _c:Float;
	public var _r1:Float;
	public var _r2:Float;
	public var _r3:Float;
	public var _r4:Float;
	public var _r5:Float;
	public var _r123:Float;
	public var _r45:Float;
	public var _rb:Float;
	public var _z:Float;
	public var _m:Float;
	public var _e:Float;
	public var _o:Float;
	public var _t:Float;
	public var _p:Float;
	public var _preC:Float;
	public var _trashXPosWidth:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_trashByDistance():Void
	{
		_customEvent_selectTrash();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_selectTrash():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_rect():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_parabolaLeft():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_parabolaRight():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_createParabolaTrash():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_randomTrash():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_findParabola():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_createDotsParabolaLeft():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_createDotsParabolaRight():Void
	{
		
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
		_trashYPos = 0.0;
		nameMap.set("spawning", "_spawning");
		_spawning = false;
		nameMap.set("dot1X", "_dot1X");
		_dot1X = 0.0;
		nameMap.set("dot1Y", "_dot1Y");
		_dot1Y = 0.0;
		nameMap.set("dot2X", "_dot2X");
		_dot2X = 0.0;
		nameMap.set("dot2Y", "_dot2Y");
		_dot2Y = 0.0;
		nameMap.set("dot3X", "_dot3X");
		_dot3X = 0.0;
		nameMap.set("dot3Y", "_dot3Y");
		_dot3Y = 0.0;
		nameMap.set("a", "_a");
		_a = 0.0;
		nameMap.set("b", "_b");
		_b = 0.0;
		nameMap.set("c", "_c");
		_c = 0.0;
		nameMap.set("r1", "_r1");
		_r1 = 0.0;
		nameMap.set("r2", "_r2");
		_r2 = 0.0;
		nameMap.set("r3", "_r3");
		_r3 = 0.0;
		nameMap.set("r4", "_r4");
		_r4 = 0.0;
		nameMap.set("r5", "_r5");
		_r5 = 0.0;
		nameMap.set("r123", "_r123");
		_r123 = 0.0;
		nameMap.set("r45", "_r45");
		_r45 = 0.0;
		nameMap.set("rb", "_rb");
		_rb = 0.0;
		nameMap.set("z", "_z");
		_z = 0.0;
		nameMap.set("m", "_m");
		_m = 0.0;
		nameMap.set("e", "_e");
		_e = 0.0;
		nameMap.set("o", "_o");
		_o = 0.0;
		nameMap.set("t", "_t");
		_t = 0.0;
		nameMap.set("p", "_p");
		_p = 0.0;
		nameMap.set("preC", "_preC");
		_preC = 0.0;
		nameMap.set("trashXPosWidth", "_trashXPosWidth");
		_trashXPosWidth = 0.0;
		
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
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(Engine.engine.getGameAttribute("spawnTrash"))
				{
					/* updating SpawnTrash */
					_customEvent_trashByDistance();
					Engine.engine.setGameAttribute("spawnTrash", false);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}