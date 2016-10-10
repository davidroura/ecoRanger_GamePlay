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



class Design_92_92_recyclingMovement extends ActorScript
{
	public var _beltSpeed:Float;
	public var _onPad:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("beltSpeed", "_beltSpeed");
		_beltSpeed = 60.0;
		nameMap.set("onPad", "_onPad");
		_onPad = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("recyclingBeltSpeed", 45);
		actor.setYVelocity(Engine.engine.getGameAttribute("recyclingBeltSpeed"));
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(4),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((_onPad == false))
				{
					actor.setYVelocity(0);
					_onPad = true;
					propertyChanged("_onPad", _onPad);
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("right", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				actor.setYVelocity(0);
				actor.setXVelocity(Engine.engine.getGameAttribute("recyclingBeltSpeed"));
				runLater(1000 * .3, function(timeTask:TimedTask):Void
				{
					actor.setYVelocity(Engine.engine.getGameAttribute("recyclingBeltSpeed"));
					actor.setXVelocity(0);
				}, actor);
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("left", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				actor.setYVelocity(0);
				actor.setXVelocity((Engine.engine.getGameAttribute("recyclingBeltSpeed") * -1));
				runLater(1000 * .3, function(timeTask:TimedTask):Void
				{
					actor.setYVelocity(Engine.engine.getGameAttribute("recyclingBeltSpeed"));
					actor.setXVelocity(0);
				}, actor);
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("down", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				actor.setYVelocity(Engine.engine.getGameAttribute("recyclingBeltSpeed"));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}