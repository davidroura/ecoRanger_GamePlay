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



class ActorEvents_112 extends ActorScript
{
	public var _dozerClick:Bool;
	public var _botAnimation:String;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("dozerClick", "_dozerClick");
		_dozerClick = false;
		nameMap.set("botAnimation", "_botAnimation");
		_botAnimation = "";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(actor, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				if(!(Engine.engine.getGameAttribute("botOn")))
				{
					Engine.engine.setGameAttribute("clickingButton", true);
					createRecycledActor(getActorType(275), (Engine.engine.getGameAttribute("playerXPos") - 30), (Engine.engine.getGameAttribute("playerYPos") - 60), Script.FRONT);
					runLater(1000 * .6, function(timeTask:TimedTask):Void
					{
						if((actor.getAnimation() == "gadget"))
						{
							createRecycledActor(getActorType(141), Engine.engine.getGameAttribute("playerXPos"), (Engine.engine.getGameAttribute("playerYPos") - Engine.engine.getGameAttribute("botOffset")), Script.FRONT);
							Engine.engine.setGameAttribute("botOn", true);
						}
						if((actor.getAnimation() == "planter"))
						{
							createRecycledActor(getActorType(151), Engine.engine.getGameAttribute("playerXPos"), (Engine.engine.getGameAttribute("playerYPos") - Engine.engine.getGameAttribute("botOffset")), Script.FRONT);
							Engine.engine.setGameAttribute("botOn", true);
						}
						if((actor.getAnimation() == "dozey"))
						{
							createRecycledActor(getActorType(228), Engine.engine.getGameAttribute("playerXPos"), (Engine.engine.getGameAttribute("playerYPos") - Engine.engine.getGameAttribute("botOffset")), Script.FRONT);
							Engine.engine.setGameAttribute("botOn", true);
						}
						if((actor.getAnimation() == "sucker"))
						{
							createRecycledActor(getActorType(143), 50, 50, Script.FRONT);
							Engine.engine.setGameAttribute("botOn", true);
						}
						_botAnimation = actor.getAnimation();
						propertyChanged("_botAnimation", _botAnimation);
						actor.fadeTo(0 / 100, .1, Linear.easeNone);
						runLater(1000 * .1, function(timeTask:TimedTask):Void
						{
							actor.setAnimation("" + "none");
						}, actor);
						runLater(1000 * 5, function(timeTask:TimedTask):Void
						{
							actor.setAnimation("" + _botAnimation);
							actor.fadeTo(100 / 100, .3, Linear.easeNone);
						}, actor);
					}, actor);
				}
			}
		});
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(actor, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && -1 == mouseState)
			{
				Engine.engine.setGameAttribute("clickingButton", false);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}