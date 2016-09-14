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



class ActorEvents_63 extends ActorScript
{
	public var _dozerArrive:Bool;
	public var _dozerLife:Float;
	public var _dozerLeave:Bool;
	public var _dozerPlaying:Bool;
	public var _dozerAdjustY:Bool;
	public var _dozerRecharge:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dozerLeaves():Void
	{
		if((actor.getX() > -50))
		{
			actor.setX((actor.getX() - 1));
		}
		if(((Engine.engine.getGameAttribute("playerYPos") + 100) > actor.getY()))
		{
			actor.setY((actor.getY() + 2));
		}
		if(((-49 > actor.getX()) && (actor.getY() > (Engine.engine.getGameAttribute("playerYPos") + 99))))
		{
			Engine.engine.setGameAttribute("dozerStrengthUnits", (Engine.engine.getGameAttribute("dozerStrengthUnits") - 1));
			runLater(1000 * 2, function(timeTask:TimedTask):Void
			{
				if((Engine.engine.getGameAttribute("dozerStrength") > 0))
				{
					Engine.engine.setGameAttribute("dozerPlaying", false);
				}
				Engine.engine.setGameAttribute("dozerStrength", (Engine.engine.getGameAttribute("dozerStrength") - 1));
				recycleActor(actor);
			}, actor);
		}
		else
		{
			_dozerLeave = true;
			propertyChanged("_dozerLeave", _dozerLeave);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dozerArrive():Void
	{
		if((69 > actor.getX()))
		{
			actor.setX((actor.getX() + 1));
		}
		else
		{
			actor.setX(Engine.engine.getGameAttribute("playerXPos"));
		}
		if((actor.getY() > (Engine.engine.getGameAttribute("playerYPos") - 150)))
		{
			actor.setY((actor.getY() - 2));
		}
		if(((Engine.engine.getGameAttribute("playerYPos") - 149) > actor.getY()))
		{
			_dozerArrive = false;
			propertyChanged("_dozerArrive", _dozerArrive);
			_dozerAdjustY = true;
			propertyChanged("_dozerAdjustY", _dozerAdjustY);
			_dozerPlaying = true;
			propertyChanged("_dozerPlaying", _dozerPlaying);
		}
		else
		{
			_dozerArrive = true;
			propertyChanged("_dozerArrive", _dozerArrive);
		}
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("dozerArrive", "_dozerArrive");
		_dozerArrive = false;
		nameMap.set("dozerLife", "_dozerLife");
		_dozerLife = 0.0;
		nameMap.set("dozerLeave", "_dozerLeave");
		_dozerLeave = false;
		nameMap.set("dozerPlaying", "_dozerPlaying");
		_dozerPlaying = false;
		nameMap.set("dozerAdjustY", "_dozerAdjustY");
		_dozerAdjustY = false;
		nameMap.set("dozerRecharge", "_dozerRecharge");
		_dozerRecharge = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_dozerArrive = true;
		propertyChanged("_dozerArrive", _dozerArrive);
		_dozerLife = asNumber(1);
		propertyChanged("_dozerLife", _dozerLife);
		_dozerLeave = false;
		propertyChanged("_dozerLeave", _dozerLeave);
		_dozerPlaying = false;
		propertyChanged("_dozerPlaying", _dozerPlaying);
		_dozerRecharge = false;
		propertyChanged("_dozerRecharge", _dozerRecharge);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_dozerArrive)
				{
					_customEvent_dozerArrive();
				}
				if(_dozerLeave)
				{
					_customEvent_dozerLeaves();
				}
				if(_dozerAdjustY)
				{
					if(((Engine.engine.getGameAttribute("playerYPos") - 75) > actor.getY()))
					{
						actor.setY((actor.getY() + 0.5));
					}
					else
					{
						_dozerAdjustY = false;
						propertyChanged("_dozerAdjustY", _dozerAdjustY);
					}
				}
				if(_dozerPlaying)
				{
					actor.setX((Engine.engine.getGameAttribute("playerXPos") - 25));
				}
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(63).ID, getActorType(12).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_dozerArrive = false;
				propertyChanged("_dozerArrive", _dozerArrive);
				_dozerAdjustY = false;
				propertyChanged("_dozerAdjustY", _dozerAdjustY);
				_dozerPlaying = false;
				propertyChanged("_dozerPlaying", _dozerPlaying);
				_dozerLeave = true;
				propertyChanged("_dozerLeave", _dozerLeave);
				_dozerRecharge = true;
				propertyChanged("_dozerRecharge", _dozerRecharge);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}