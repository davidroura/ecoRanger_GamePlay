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



class SceneEvents_9 extends SceneScript
{
	public var _bottlesPos:Float;
	public var _bottles2:String;
	public var _bottles3:String;
	public var _bottles4:String;
	public var _timeCounter:Float;
	public var _seconds:Float;
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("bottlesPos", "_bottlesPos");
		_bottlesPos = 0.0;
		nameMap.set("bottles2", "_bottles2");
		nameMap.set("bottles3", "_bottles3");
		nameMap.set("bottles4", "_bottles4");
		nameMap.set("timeCounter", "_timeCounter");
		_timeCounter = 0.0;
		nameMap.set("seconds", "_seconds");
		_seconds = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_bottlesPos = asNumber(0);
		propertyChanged("_bottlesPos", _bottlesPos);
		Engine.engine.setGameAttribute("glassAnimation", 0);
		Engine.engine.setGameAttribute("bottleDone", 0);
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(29),a.getType(),a.getGroup()))
			{
				createRecycledActor(getActorType(33), 100, 230, Script.FRONT);
				if((_bottlesPos == 3))
				{
					_bottlesPos = asNumber(0);
					propertyChanged("_bottlesPos", _bottlesPos);
					Engine.engine.setGameAttribute("glassAnimation", (Engine.engine.getGameAttribute("glassAnimation") + 1));
				}
				_bottlesPos = asNumber((_bottlesPos + 1));
				propertyChanged("_bottlesPos", _bottlesPos);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}