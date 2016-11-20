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



class Design_98_98_powerUpsucker extends ActorScript
{
	public var _TargetActor:Actor;
	public var _DistanceX:Float;
	public var _DistanceY:Float;
	public var _Distance:Float;
	public var _Direction:Float;
	public var _Speed:Float;
	public var _Margin:Float;
	public var _Easing:Bool;
	public var _MinimumEasingSpeed:Float;
	public var _StopwhenColliding:Bool;
	public var _Collided:Bool;
	public var _suckingSpeed:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Target Actor", "_TargetActor");
		nameMap.set("Distance X", "_DistanceX");
		_DistanceX = 0.0;
		nameMap.set("Distance Y", "_DistanceY");
		_DistanceY = 0.0;
		nameMap.set("Distance", "_Distance");
		_Distance = 0.0;
		nameMap.set("Direction", "_Direction");
		_Direction = 0.0;
		nameMap.set("Speed", "_Speed");
		_Speed = 30.0;
		nameMap.set("Margin", "_Margin");
		_Margin = 0.0;
		nameMap.set("Easing", "_Easing");
		_Easing = true;
		nameMap.set("Minimum Easing Speed", "_MinimumEasingSpeed");
		_MinimumEasingSpeed = 5.0;
		nameMap.set("Stop when Colliding", "_StopwhenColliding");
		_StopwhenColliding = true;
		nameMap.set("Collided", "_Collided");
		_Collided = false;
		nameMap.set("suckingSpeed", "_suckingSpeed");
		_suckingSpeed = 0.3;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(Engine.engine.getGameAttribute("suckingPowerOn"))
				{
					_DistanceX = asNumber(((Engine.engine.getGameAttribute("playerXPos") + 15) - actor.getXCenter()));
					propertyChanged("_DistanceX", _DistanceX);
					_DistanceY = asNumber(((Engine.engine.getGameAttribute("playerYPos") + 20) - actor.getYCenter()));
					propertyChanged("_DistanceY", _DistanceY);
					_Distance = asNumber(Math.sqrt((Math.pow(_DistanceX, 2) + Math.pow(_DistanceY, 2))));
					propertyChanged("_Distance", _Distance);
					if((_Distance < 165))
					{
						_Direction = asNumber(Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)));
						propertyChanged("_Direction", _Direction);
						actor.setVelocity(_Direction, (.03 + Engine.engine.getGameAttribute("sceneSpeed")));
						_suckingSpeed = asNumber((.03 * 2));
						propertyChanged("_suckingSpeed", _suckingSpeed);
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}