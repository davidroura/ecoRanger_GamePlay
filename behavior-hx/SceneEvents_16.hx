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



class SceneEvents_16 extends SceneScript
{
	public var _onPad:Bool;
	public var _trashType:Float;
	public var _spawnWait:Bool;
	public var _trashPos:Float;
	public var _trashSeed:Float;
	public var _tempTrashCounter:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_randomSpawn():Void
	{
		/* decide where trash goes */
		_trashSeed = asNumber(randomInt(Math.floor(0), Math.floor(2)));
		propertyChanged("_trashSeed", _trashSeed);
		if((_trashSeed == 0))
		{
			_trashPos = asNumber(randomInt(Math.floor(170), Math.floor(225)));
			propertyChanged("_trashPos", _trashPos);
		}
		else if((_trashSeed == 1))
		{
			_trashPos = asNumber(randomInt(Math.floor(265), Math.floor(325)));
			propertyChanged("_trashPos", _trashPos);
		}
		else
		{
			_trashPos = asNumber(randomInt(Math.floor(365), Math.floor(445)));
			propertyChanged("_trashPos", _trashPos);
		}
		/* choose random trash */
		runLater(1000 * randomFloatBetween(.01, 1.5), function(timeTask:TimedTask):Void
		{
			_trashType = asNumber(randomInt(Math.floor(0), Math.floor(2)));
			propertyChanged("_trashType", _trashType);
			if(((_trashType == 0) && (Engine.engine.getGameAttribute("total_cans") >= 1)))
			{
				createRecycledActor(getActorType(131), -5, _trashPos, Script.FRONT);
			}
			if(((_trashType == 1) && (Engine.engine.getGameAttribute("total_glassBottles") >= 1)))
			{
				createRecycledActor(getActorType(137), -5, _trashPos, Script.FRONT);
			}
			if(((_trashType == 2) && (Engine.engine.getGameAttribute("total_plasticBottles") >= 1)))
			{
				createRecycledActor(getActorType(139), -5, _trashPos, Script.FRONT);
			}
			_spawnWait = false;
			propertyChanged("_spawnWait", _spawnWait);
		}, null);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_recyclingTutorial():Void
	{
		/* Not being used right now */
		createRecycledActor(getActorType(131), 70, -5, Script.FRONT);
		runLater(1000 * .5, function(timeTask:TimedTask):Void
		{
			Engine.engine.setGameAttribute("sceneSpeedHold", Engine.engine.getGameAttribute("recyclingBeltSpeed"));
			Engine.engine.setGameAttribute("recyclingBeltSpeed", 0);
		}, null);
		runLater(1000 * 1.5, function(timeTask:TimedTask):Void
		{
			recycleActor(getLastCreatedActor());
			createRecycledActor(getActorType(188), -35, 12, Script.FRONT);
			getLastCreatedActor().setAnimation("" + "handClose");
		}, null);
		runLater(1000 * 2, function(timeTask:TimedTask):Void
		{
			getLastCreatedActor().setXVelocity(15);
			getLastCreatedActor().setYVelocity(23);
		}, null);
		runLater(1000 * 3, function(timeTask:TimedTask):Void
		{
			getLastCreatedActor().setXVelocity(0);
			getLastCreatedActor().setYVelocity(0);
		}, null);
		runLater(1000 * 3.5, function(timeTask:TimedTask):Void
		{
			getLastCreatedActor().setAnimation("" + "handOpen");
			getLastCreatedActor().fadeTo(0, 1, Linear.easeNone);
		}, null);
		runLater(1000 * 5.5, function(timeTask:TimedTask):Void
		{
			Engine.engine.setGameAttribute("recyclingBeltSpeed", Engine.engine.getGameAttribute("sceneSpeedHold"));
			Engine.engine.setGameAttribute("found_recycling", true);
			_spawnWait = false;
			propertyChanged("_spawnWait", _spawnWait);
		}, null);
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("onPad", "_onPad");
		_onPad = false;
		nameMap.set("trashType", "_trashType");
		_trashType = 0.0;
		nameMap.set("spawnWait", "_spawnWait");
		_spawnWait = false;
		nameMap.set("trashPos", "_trashPos");
		_trashPos = 0.0;
		nameMap.set("trashSeed", "_trashSeed");
		_trashSeed = 0.0;
		nameMap.set("tempTrashCounter", "_tempTrashCounter");
		_tempTrashCounter = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_tempTrashCounter = asNumber(15);
		propertyChanged("_tempTrashCounter", _tempTrashCounter);
		Engine.engine.setGameAttribute("recyclingBeltSpeed", 15);
		/* picking the right asset animations */
		getActor(5).setAnimation("" + "aluminum");
		getActor(12).setAnimation("" + "glass");
		getActor(39).setAnimation("" + "glass");
		getActor(41).setAnimation("" + "aluminum");
		getActor(42).setAnimation("" + "plasticWash");
		getActor(43).setAnimation("" + "glassWash");
		getActor(44).setAnimation("" + "aluminumWash");
		getActor(45).setAnimation("" + "crush");
		getActor(46).setAnimation("" + "crush");
		getActor(47).setAnimation("" + "crush");
		Engine.engine.setGameAttribute("total_cans", 10);
		Engine.engine.setGameAttribute("total_plasticBottles", 10);
		Engine.engine.setGameAttribute("total_glassBottles", 10);
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				/* if there isn't trash trigger end animation */
				if((_tempTrashCounter <= 0))
				{
					if(!(Engine.engine.getGameAttribute("recycleScoreAnimation")))
					{
						runLater(1000 * 6, function(timeTask:TimedTask):Void
						{
							Engine.engine.setGameAttribute("recyclingBeltSpeed", 4);
							getActor(14).setAnimation("" + "drop");
							getActor(15).setAnimation("" + "drop");
							getActor(16).setAnimation("" + "drop");
						}, null);
						createRecycledActor(getActorType(215), 7, 26, Script.FRONT);
						Engine.engine.setGameAttribute("recycleScoreAnimation", true);
					}
				}
				/* if you aren't waiting for next trash spawn, then create trash */
				else
				{
					if(!(_spawnWait))
					{
						_customEvent_randomSpawn();
						_spawnWait = true;
						propertyChanged("_spawnWait", _spawnWait);
						_tempTrashCounter = asNumber((_tempTrashCounter - 1));
						propertyChanged("_tempTrashCounter", _tempTrashCounter);
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(139),a.getType(),a.getGroup()))
			{
				createRecycledActor(getActorType(210), randomInt(Math.floor(200), Math.floor(300)), randomInt(Math.floor(164), Math.floor(230)), Script.FRONT);
				playSound(getSound(212));
				Engine.engine.setGameAttribute("plastic", (Engine.engine.getGameAttribute("plastic") + 1));
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(1), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(139),a.getType(),a.getGroup()))
			{
				playSound(getSound(214));
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(2), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(139),a.getType(),a.getGroup()))
			{
				playSound(getSound(214));
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(1), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(137),a.getType(),a.getGroup()))
			{
				createRecycledActor(getActorType(210), randomInt(Math.floor(200), Math.floor(300)), randomInt(Math.floor(260), Math.floor(330)), Script.FRONT);
				playSound(getSound(212));
				recycleActor(a);
				Engine.engine.setGameAttribute("glass", (Engine.engine.getGameAttribute("glass") + 1));
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(137),a.getType(),a.getGroup()))
			{
				playSound(getSound(214));
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(2), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(137),a.getType(),a.getGroup()))
			{
				playSound(getSound(214));
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(2), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(131),a.getType(),a.getGroup()))
			{
				createRecycledActor(getActorType(210), randomInt(Math.floor(200), Math.floor(300)), randomInt(Math.floor(365), Math.floor(450)), Script.FRONT);
				playSound(getSound(212));
				recycleActor(a);
				Engine.engine.setGameAttribute("aluminum", (Engine.engine.getGameAttribute("aluminum") + 1));
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(1), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(131),a.getType(),a.getGroup()))
			{
				recycleActor(a);
				playSound(getSound(214));
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(131),a.getType(),a.getGroup()))
			{
				recycleActor(a);
				playSound(getSound(214));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}