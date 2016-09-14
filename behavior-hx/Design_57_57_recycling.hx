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



class Design_57_57_recycling extends SceneScript
{
	public var _showerActor:Actor;
	public var _hammerActor:Actor;
	public var _timeCounter:Float;
	public var _hammerCreated:Bool;
	public var _numberBottles:Float;
	public var _seconds:Float;
	public var _secondsCountDown:Float;
	public var _secondsString:String;
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("showerActor", "_showerActor");
		nameMap.set("hammerActor", "_hammerActor");
		nameMap.set("timeCounter", "_timeCounter");
		_timeCounter = 0.0;
		nameMap.set("hammerCreated", "_hammerCreated");
		_hammerCreated = false;
		nameMap.set("numberBottles", "_numberBottles");
		_numberBottles = 0.0;
		nameMap.set("seconds", "_seconds");
		_seconds = 0.0;
		nameMap.set("secondsCountDown", "_secondsCountDown");
		_secondsCountDown = 0.0;
		nameMap.set("secondsString", "_secondsString");
		_secondsString = "";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		createRecycledActor(getActorType(31), 130, -1, Script.FRONT);
		_showerActor = getLastCreatedActor();
		propertyChanged("_showerActor", _showerActor);
		_hammerCreated = false;
		propertyChanged("_hammerCreated", _hammerCreated);
		_numberBottles = asNumber(4);
		propertyChanged("_numberBottles", _numberBottles);
		_secondsCountDown = asNumber(30);
		propertyChanged("_secondsCountDown", _secondsCountDown);
		runPeriodically(1000 * 1, function(timeTask:TimedTask):Void
		{
			_seconds = asNumber((_seconds + 1));
			propertyChanged("_seconds", _seconds);
			_secondsCountDown = asNumber((_secondsCountDown - 1));
			propertyChanged("_secondsCountDown", _secondsCountDown);
			if((_secondsCountDown > 10))
			{
				_secondsString = ("" + _secondsCountDown);
				propertyChanged("_secondsString", _secondsString);
			}
			else
			{
				_secondsString = (("" + "0") + ("" + ("" + _secondsCountDown)));
				propertyChanged("_secondsString", _secondsString);
			}
		}, null);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((_seconds == 15))
				{
					_secondsCountDown = asNumber(30);
					propertyChanged("_secondsCountDown", _secondsCountDown);
					if(!(_hammerCreated))
					{
						recycleActor(_showerActor);
						createRecycledActor(getActorType(29), 130, -1, Script.FRONT);
						_hammerActor = getLastCreatedActor();
						propertyChanged("_hammerActor", _hammerActor);
						_hammerCreated = true;
						propertyChanged("_hammerCreated", _hammerCreated);
					}
				}
				else if((_seconds == 30))
				{
					switchScene(GameModel.get().scenes.get(11).getID(), null, createCrossfadeTransition(0));
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(54));
				g.drawString("" + (("" + "00:") + ("" + _secondsString)), 640, 10);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}