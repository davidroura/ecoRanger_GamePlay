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



class Design_28_28_recyclingGlass extends ActorScript
{
	public var _bottlesPos:Float;
	public var _bottles2:String;
	public var _bottles3:String;
	public var _bottles4:String;
	public var _bottles1:String;
	public var _colliedTimer:Float;
	public var _bottleCleaned:Bool;
	public var _bottles5:String;
	public var _bottles6:String;
	public var _bottles7:String;
	public var _bottleCrashed:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("bottlesPos", "_bottlesPos");
		_bottlesPos = 0.0;
		nameMap.set("bottles2", "_bottles2");
		nameMap.set("bottles3", "_bottles3");
		nameMap.set("bottles4", "_bottles4");
		nameMap.set("bottles1", "_bottles1");
		nameMap.set("colliedTimer", "_colliedTimer");
		_colliedTimer = 0.0;
		nameMap.set("bottleCleaned", "_bottleCleaned");
		_bottleCleaned = false;
		nameMap.set("bottles5", "_bottles5");
		nameMap.set("bottles6", "_bottles6");
		nameMap.set("bottles7", "_bottles7");
		nameMap.set("bottleCrashed", "_bottleCrashed");
		_bottleCrashed = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_bottleCleaned = false;
		propertyChanged("_bottleCleaned", _bottleCleaned);
		_bottleCrashed = false;
		propertyChanged("_bottleCrashed", _bottleCrashed);
		_colliedTimer = asNumber(0);
		propertyChanged("_colliedTimer", _colliedTimer);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((_colliedTimer > 520))
				{
					actor.setAnimation("" + _bottles7);
					if(!(_bottleCrashed))
					{
						Engine.engine.setGameAttribute("bottleDone", (Engine.engine.getGameAttribute("bottleDone") + 1));
						_bottleCrashed = true;
						propertyChanged("_bottleCrashed", _bottleCrashed);
					}
				}
				else if((_colliedTimer > 500))
				{
					actor.setAnimation("" + _bottles6);
				}
				else if((_colliedTimer > 420))
				{
					actor.setAnimation("" + _bottles5);
				}
				else if((_colliedTimer > 380))
				{
					actor.setAnimation("" + _bottles4);
					if(!(_bottleCleaned))
					{
						Engine.engine.setGameAttribute("bottleDone", (Engine.engine.getGameAttribute("bottleDone") + 1));
						_bottleCleaned = true;
						propertyChanged("_bottleCleaned", _bottleCleaned);
					}
				}
				else if((_colliedTimer > 300))
				{
					actor.setAnimation("" + _bottles3);
				}
				else if((_colliedTimer > 200))
				{
					actor.setAnimation("" + _bottles2);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(31), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!(_bottleCleaned))
				{
					_colliedTimer = asNumber((_colliedTimer + 1));
					propertyChanged("_colliedTimer", _colliedTimer);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(29), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_bottlesPos = asNumber((_bottlesPos + 1));
				propertyChanged("_bottlesPos", _bottlesPos);
				_colliedTimer = asNumber((_colliedTimer + 1));
				propertyChanged("_colliedTimer", _colliedTimer);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}