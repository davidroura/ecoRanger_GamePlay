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



class Design_36_36_roatePot extends ActorScript
{
	public var _rotation:Float;
	public var _animation1:String;
	public var _animation2:String;
	public var _animation3:String;
	public var _createdAnimation:Bool;
	public var _animation4:String;
	public var _counter:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("rotation", "_rotation");
		_rotation = 0.0;
		nameMap.set("animation1", "_animation1");
		nameMap.set("animation2", "_animation2");
		nameMap.set("animation3", "_animation3");
		nameMap.set("createdAnimation", "_createdAnimation");
		_createdAnimation = false;
		nameMap.set("animation4", "_animation4");
		nameMap.set("counter", "_counter");
		_counter = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_rotation = asNumber(0);
		propertyChanged("_rotation", _rotation);
		_counter = asNumber(0);
		propertyChanged("_counter", _counter);
		_createdAnimation = false;
		propertyChanged("_createdAnimation", _createdAnimation);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(((1 > _rotation) || (_rotation > -120)))
				{
					actor.setAngle(Utils.RAD * (_rotation));
					if(Input.swipedRight)
					{
						_rotation = asNumber((_rotation - 10));
						propertyChanged("_rotation", _rotation);
					}
					if(Input.swipedLeft)
					{
						_rotation = asNumber((_rotation + 10));
						propertyChanged("_rotation", _rotation);
					}
					_rotation = asNumber((_rotation + (Input.accelX * -1)));
					propertyChanged("_rotation", _rotation);
				}
				if((-120 > _rotation))
				{
					_counter = asNumber((_counter + 1));
					propertyChanged("_counter", _counter);
					if((_counter > 300))
					{
						switchScene(GameModel.get().scenes.get(12).getID(), null, createCrossfadeTransition(0));
					}
				}
				else if((-119 > _rotation))
				{
					actor.setAnimation("" + _animation4);
				}
				else if((-109 > _rotation))
				{
					actor.setAnimation("" + _animation3);
				}
				else if((-99 > _rotation))
				{
					actor.setAnimation("" + _animation2);
				}
				else if((-89 > _rotation))
				{
					actor.setAnimation("" + _animation1);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}