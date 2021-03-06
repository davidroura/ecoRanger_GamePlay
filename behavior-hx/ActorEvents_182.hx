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



class ActorEvents_182 extends ActorScript
{
	public var _buttonOn:Bool;
	public var _searchIndex:Float;
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_findInList(__searchItem:String, __searchList:Array<Dynamic>):Float
	{
		var __Self:Actor = actor;
		for(item in cast(__searchList, Array<Dynamic>))
		{
			if((item == __searchItem))
			{
				return _searchIndex;
			}
			_searchIndex = asNumber((_searchIndex + 1));
			propertyChanged("_searchIndex", _searchIndex);
		}
		return -1;
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("buttonOn", "_buttonOn");
		_buttonOn = false;
		nameMap.set("searchIndex", "_searchIndex");
		_searchIndex = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		runLater(1000 * .2, function(timeTask:TimedTask):Void
		{
			trace("" + actor.getAnimation());
			if((("" + actor.getAnimation()).indexOf("Off") == -1))
			{
				_buttonOn = true;
				propertyChanged("_buttonOn", _buttonOn);
			}
		}, actor);
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(actor, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				trace("" + "*******************************************************************************************************************");
				trace("" + (("" + "index ") + ("" + Engine.engine.getGameAttribute("totalSelectedBots"))));
				trace("" + (("" + "buttonOn is") + ("" + ("" + _buttonOn))));
				if(_buttonOn)
				{
					/* button turns OFF and it's replaced from bot list with "none" */
					trace("" + "button turned Off");
					trace("" + (("" + "clicked on bot ") + ("" + actor.getAnimation())));
					actor.setAnimation("" + StringTools.replace(("" + ("" + actor.getAnimation())), ("" + "On"), ("" + "Off")));
					/* find index of bots name and replace it with "none" */
					Engine.engine.getGameAttribute("selectedBotList")[Std.int(cast(actor.say("ActorEvents_182", "_customBlock_findInList", [StringTools.replace(("" + ("" + actor.getAnimation())), ("" + "Off"), ("" + "")), Engine.engine.getGameAttribute("selectedBotList")]), Float))] = "none";
					Engine.engine.setGameAttribute("totalSelectedBots", (Engine.engine.getGameAttribute("totalSelectedBots") - 1));
					_buttonOn = false;
					propertyChanged("_buttonOn", _buttonOn);
				}
				else if((!(_buttonOn) && (Engine.engine.getGameAttribute("totalSelectedBots") <= 2)))
				{
					/* button turns ON and it's added to bot list */
					trace("" + "button turned On");
					trace("" + (("" + "clicked on bot") + ("" + actor.getAnimation())));
					Engine.engine.getGameAttribute("selectedBotList")[Std.int(cast(actor.say("ActorEvents_182", "_customBlock_findInList", ["none", Engine.engine.getGameAttribute("selectedBotList")]), Float))] = StringTools.replace(("" + ("" + actor.getAnimation())), ("" + "Off"), ("" + ""));
					actor.setAnimation("" + StringTools.replace(("" + ("" + actor.getAnimation())), ("" + "Off"), ("" + "On")));
					_buttonOn = true;
					propertyChanged("_buttonOn", _buttonOn);
					Engine.engine.setGameAttribute("totalSelectedBots", (Engine.engine.getGameAttribute("totalSelectedBots") + 1));
				}
				trace("" + "**bots**");
				for(item in cast(Engine.engine.getGameAttribute("selectedBotList"), Array<Dynamic>))
				{
					trace("" + item);
				}
				trace("" + "*****");
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
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