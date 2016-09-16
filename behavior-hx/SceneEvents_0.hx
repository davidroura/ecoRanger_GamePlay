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



class SceneEvents_0 extends SceneScript
{
	public var _dozerArrive:Bool;
	public var _dozerClick:Bool;
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("dozerArrive", "_dozerArrive");
		_dozerArrive = false;
		nameMap.set("dozerClick", "_dozerClick");
		_dozerClick = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("sceneSpeed", 15);
		Engine.engine.setGameAttribute("lateralSpeed", 0);
		Engine.engine.setGameAttribute("playerControl", true);
		Engine.engine.setGameAttribute("dozerPlaying", false);
		getActor(1).setAnimation("" + "Animation Up");
		runLater(1000 * 0.5, function(timeTask:TimedTask):Void
		{
			getActor(1).setAnimation("" + "Animation Up");
		}, null);
		loopSoundOnChannel(getSound(103), Std.int(5));
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(8),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(104),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(15),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(getActor(2), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				_dozerClick = true;
				propertyChanged("_dozerClick", _dozerClick);
				if(((Engine.engine.getGameAttribute("dozerStrength") > 0) && !(Engine.engine.getGameAttribute("dozerPlaying"))))
				{
					getActor(2).setAnimation("" + "Off");
					createRecycledActor(getActorType(63), -5, Engine.engine.getGameAttribute("playerYPos"), Script.FRONT);
					Engine.engine.setGameAttribute("dozerStrengthUnits", (Engine.engine.getGameAttribute("dozerStrengthUnits") + 1));
					Engine.engine.setGameAttribute("dozerPlaying", true);
					getLastCreatedActor().growTo(25/100, 25/100, 0, Linear.easeNone);
				}
				_dozerClick = false;
				propertyChanged("_dozerClick", _dozerClick);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(10),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(12),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}