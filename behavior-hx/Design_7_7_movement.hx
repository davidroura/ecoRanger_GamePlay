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



class Design_7_7_movement extends ActorScript
{
	public var _standAnimation:String;
	public var _showInfo:Bool;
	public var _movementCounter:Float;
	public var _movementText:String;
	public var _currentYPos:Float;
	public var _standAnimationBoosted:String;
	public var _pointUp:Float;
	public var _maxLeft:Float;
	public var _maxRight:Float;
	public var _turnSpeed:Float;
	public var _width:Float;
	public var _accelTurnSpeed:Float;
	public var _mouseDown:Bool;
	public var _boundaryLeft:Float;
	public var _boundaryRight:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_move():Void
	{
		_customEvent_animation();
		if(Engine.engine.getGameAttribute("playerControl"))
		{
			if(Engine.engine.getGameAttribute("slowMovement"))
			{
				_customEvent_counter();
				_customEvent_slowMovement();
			}
			else
			{
				_currentYPos = asNumber(Engine.engine.getGameAttribute("playerYPos"));
				propertyChanged("_currentYPos", _currentYPos);
			}
			actor.setY(_currentYPos);
			actor.setX(actor.getX());
		}
		if(Engine.engine.getGameAttribute("accelerometerControl"))
		{
			_customEvent_accelerometerControl();
		}
		else
		{
			_customEvent_touchControl();
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_animation():Void
	{
		if(Engine.engine.getGameAttribute("planterPower"))
		{
			actor.setAnimation("" + "dirt");
		}
		else if(Engine.engine.getGameAttribute("boosted"))
		{
			actor.setAnimation("" + _standAnimationBoosted);
		}
		else
		{
			actor.setAnimation("" + _standAnimation);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_slowMovement():Void
	{
		if((_currentYPos > Engine.engine.getGameAttribute("playerYPos")))
		{
			_currentYPos = asNumber((_currentYPos - 1));
			propertyChanged("_currentYPos", _currentYPos);
		}
		else if((Engine.engine.getGameAttribute("playerYPos") > _currentYPos))
		{
			_currentYPos = asNumber((_currentYPos + 1));
			propertyChanged("_currentYPos", _currentYPos);
		}
		else
		{
			_currentYPos = asNumber(Engine.engine.getGameAttribute("playerYPos"));
			propertyChanged("_currentYPos", _currentYPos);
			Engine.engine.setGameAttribute("slowMovement", false);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_counter():Void
	{
		_movementCounter = asNumber((_movementCounter + 1));
		propertyChanged("_movementCounter", _movementCounter);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_accelerometerControl():Void
	{
		actor.setAngle(Utils.RAD * ((Input.accelX * -(100))));
		if((Input.accelX > 0))
		{
			_customEvent_accelLeft();
		}
		else if((0 > Input.accelX))
		{
			_customEvent_accelRight();
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_accelLeft():Void
	{
		if(((actor.getX() > _boundaryLeft) && ((_boundaryRight + 1) > actor.getX())))
		{
			actor.setX((actor.getX() + 1));
		}
		Engine.engine.setGameAttribute("lateralSpeed", 0);
		_customEvent_right();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_accelRight():Void
	{
		if(((_boundaryRight > actor.getX()) && ((actor.getWidth()) > (_boundaryLeft - 1))))
		{
			actor.setX((actor.getX() - 1));
		}
		Engine.engine.setGameAttribute("lateralSpeed", 0);
		_customEvent_left();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_touchControl():Void
	{
		if(!(Engine.engine.getGameAttribute("clickingButton")))
		{
			if(isMouseDown())
			{
				_customEvent_touchLeftRight();
				_mouseDown = true;
				propertyChanged("_mouseDown", _mouseDown);
			}
			else
			{
				_customEvent_stand();
				_mouseDown = false;
				propertyChanged("_mouseDown", _mouseDown);
			}
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_touchLeftRight():Void
	{
		if(((_width / 2) < getMouseX()))
		{
			_customEvent_accelLeft();
		}
		else
		{
			_customEvent_accelRight();
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_touchLeft():Void
	{
		if((5 > Engine.engine.getGameAttribute("virtualX")))
		{
			
		}
		else if((((Engine.engine.getGameAttribute("virtualX") + getScreenWidth()) > 490) && (90 < actor.getX())))
		{
			actor.setX((actor.getX() - 1));
			Engine.engine.setGameAttribute("lateralSpeed", 0);
		}
		else
		{
			
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_touchRight():Void
	{
		if((actor.getX() > 499))
		{
			if((_width > (actor.getX() + (actor.getWidth()))))
			{
				actor.setX((actor.getX() + 1));
			}
			Engine.engine.setGameAttribute("lateralSpeed", 0);
		}
		else if(((5 > Engine.engine.getGameAttribute("virtualX")) && (actor.getX() < 90)))
		{
			actor.setX((actor.getX() + 1));
			Engine.engine.setGameAttribute("lateralSpeed", 0);
		}
		else
		{
			
		}
		_customEvent_right();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_stand():Void
	{
		if(Engine.engine.getGameAttribute("boosted"))
		{
			actor.setAnimation("" + _standAnimationBoosted);
		}
		else
		{
			actor.setAnimation("" + _standAnimation);
		}
		if((Utils.DEG * (actor.getAngle()) == _pointUp))
		{
			
		}
		else if((_pointUp < Utils.DEG * (actor.getAngle())))
		{
			actor.setAngle(Utils.RAD * ((Utils.DEG * (actor.getAngle()) - _turnSpeed)));
		}
		else if((Utils.DEG * (actor.getAngle()) < _pointUp))
		{
			actor.setAngle(Utils.RAD * ((Utils.DEG * (actor.getAngle()) + _turnSpeed)));
		}
		Engine.engine.setGameAttribute("lateralSpeed", 0);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_left():Void
	{
		actor.setAnimation("" + "left");
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_right():Void
	{
		actor.setAnimation("" + "right");
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("standAnimation", "_standAnimation");
		nameMap.set("showInfo", "_showInfo");
		_showInfo = false;
		nameMap.set("movementCounter", "_movementCounter");
		_movementCounter = 0.0;
		nameMap.set("movementText", "_movementText");
		_movementText = "";
		nameMap.set("currentYPos", "_currentYPos");
		_currentYPos = 0.0;
		nameMap.set("standAnimationBoosted", "_standAnimationBoosted");
		nameMap.set("pointUp", "_pointUp");
		_pointUp = 0.0;
		nameMap.set("maxLeft", "_maxLeft");
		_maxLeft = 0.0;
		nameMap.set("maxRight", "_maxRight");
		_maxRight = 0.0;
		nameMap.set("turnSpeed", "_turnSpeed");
		_turnSpeed = 0.0;
		nameMap.set("width", "_width");
		_width = 0.0;
		nameMap.set("accelTurnSpeed", "_accelTurnSpeed");
		_accelTurnSpeed = 0.0;
		nameMap.set("mouseDown", "_mouseDown");
		_mouseDown = false;
		nameMap.set("boundaryLeft", "_boundaryLeft");
		_boundaryLeft = 0.0;
		nameMap.set("boundaryRight", "_boundaryRight");
		_boundaryRight = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("playerYPos", 250);
		Engine.engine.setGameAttribute("slowMovement", false);
		Engine.engine.setGameAttribute("playerControl", true);
		_movementCounter = asNumber(0);
		propertyChanged("_movementCounter", _movementCounter);
		actor.setAnimation("" + _standAnimation);
		_pointUp = asNumber(0);
		propertyChanged("_pointUp", _pointUp);
		actor.setAngle(Utils.RAD * (_pointUp));
		_showInfo = false;
		propertyChanged("_showInfo", _showInfo);
		_maxLeft = asNumber(-20);
		propertyChanged("_maxLeft", _maxLeft);
		_maxRight = asNumber(20);
		propertyChanged("_maxRight", _maxRight);
		_turnSpeed = asNumber(7);
		propertyChanged("_turnSpeed", _turnSpeed);
		_width = asNumber(350);
		propertyChanged("_width", _width);
		Engine.engine.setGameAttribute("virtualX", 0);
		_boundaryLeft = asNumber(-50);
		propertyChanged("_boundaryLeft", _boundaryLeft);
		_boundaryRight = asNumber(250);
		propertyChanged("_boundaryRight", _boundaryRight);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_customEvent_move();
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_showInfo)
				{
					g.setFont(getFont(20));
					g.drawString("" + (("" + "mouse down") + ("" + ("" + isMouseDown()))), 0, 0);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}