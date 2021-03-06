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



class ActorEvents_55 extends ActorScript
{
	public var _currentButton:Float;
	public var _buttonClicked:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("currentButton", "_currentButton");
		_currentButton = 0.0;
		nameMap.set("buttonClicked", "_buttonClicked");
		_buttonClicked = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("foregroundMenuCalled", true);
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(actor, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				/* index returns -1 if not found. "If not On" */
				if((("" + actor.getAnimation()).indexOf("On") == -1))
				{
					Engine.engine.setGameAttribute("upgradeDescription", StringTools.replace(("" + actor.getAnimation()), ("" + "Off"), ("" + "")));
				}
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				/* if this button is the upgrade description button keep on, otherwise be off */
				if(((("" + Engine.engine.getGameAttribute("upgradeDescription")) + ("" + "Off")) == actor.getAnimation()))
				{
					actor.setAnimation("" + StringTools.replace(("" + actor.getAnimation()), ("" + "Off"), ("" + "On")));
				}
				else if(!((("" + Engine.engine.getGameAttribute("upgradeDescription")) + ("" + "On")) == actor.getAnimation()))
				{
					actor.setAnimation("" + StringTools.replace(("" + actor.getAnimation()), ("" + "On"), ("" + "Off")));
				}
				if((!(Engine.engine.getGameAttribute("moveUpgradeButtons") == 0) && !(Engine.engine.getGameAttribute("scrollButtonClicked"))))
				{
					_currentButton = asNumber((asNumber(StringTools.replace(("" + actor.getAnimation()), ("" + "Off"), ("" + ""))) + Engine.engine.getGameAttribute("moveUpgradeButtons")));
					propertyChanged("_currentButton", _currentButton);
					actor.setAnimation("" + (("" + ("" + _currentButton)) + ("" + "Off")));
					trace("" + (("" + actor.getAnimation()) + ("" + (("" + " to ") + ("" + (("" + ("" + _currentButton)) + ("" + "Off")))))));
					Engine.engine.setGameAttribute("buttonsMoved", (Engine.engine.getGameAttribute("buttonsMoved") + 1));
					if((Engine.engine.getGameAttribute("buttonsMoved") == 3))
					{
						Engine.engine.setGameAttribute("scrollButtonClicked", true);
						Engine.engine.setGameAttribute("buttonsMoved", 0);
					}
				}
				if(!(Engine.engine.getGameAttribute("foregroundMenuCalled")))
				{
					recycleActor(actor);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}