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



class SceneEvents_0 extends SceneScript
{
	public var _dozerArrive:Bool;
	public var _dozerClick:Bool;
	public var _points:Float;
	public var _gameOverShown:Bool;
	public var _tutorialShown:Bool;
	public var _UITutorial:Actor;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_tutorial():Void
	{
		if(!(Engine.engine.getGameAttribute("tutorialDone")))
		{
			Engine.engine.setGameAttribute("spawnThings", false);
			createRecycledActor(getActorType(119), 0, -10, Script.FRONT);
			_UITutorial = getLastCreatedActor();
			propertyChanged("_UITutorial", _UITutorial);
			runLater(1000 * 1.5, function(timeTask:TimedTask):Void
			{
				recycleActor(_UITutorial);
			}, null);
			runLater(1000 * 2, function(timeTask:TimedTask):Void
			{
				createRecycledActor(getActorType(122), 0, -10, Script.FRONT);
				_UITutorial = getLastCreatedActor();
				propertyChanged("_UITutorial", _UITutorial);
			}, null);
			runLater(1000 * 3.5, function(timeTask:TimedTask):Void
			{
				recycleActor(_UITutorial);
				Engine.engine.setGameAttribute("spawnThings", true);
			}, null);
			Engine.engine.setGameAttribute("tutorialDone", true);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_gameOverIU():Void
	{
		addBackground("UIEnd", "EndUI", 5);
		createRecycledActor(getActorType(51), 50, 280, Script.FRONT);
		createRecycledActor(getActorType(49), 140, 280, Script.FRONT);
		_points = asNumber((Engine.engine.getGameAttribute("bottleColleted") + Engine.engine.getGameAttribute("canCollected")));
		propertyChanged("_points", _points);
		Engine.engine.setGameAttribute("gameBottles", (Engine.engine.getGameAttribute("gameBottles") + Engine.engine.getGameAttribute("bottleColleted")));
		Engine.engine.setGameAttribute("gameCans", (Engine.engine.getGameAttribute("gameCans") + Engine.engine.getGameAttribute("canCollected")));
		if((_points > 1))
		{
			createRecycledActor(getActorType(17), -10, 40, Script.FRONT);
			getLastCreatedActor().setAnimation("" + "1");
		}
		if((_points > 2))
		{
			createRecycledActor(getActorType(17), 100, 40, Script.FRONT);
			getLastCreatedActor().setAnimation("" + "2");
		}
		if((_points > 3))
		{
			createRecycledActor(getActorType(17), 190, 40, Script.FRONT);
			getLastCreatedActor().setAnimation("" + "3");
		}
		saveGame("mySave", function(success:Bool):Void
		{
			if(success)
			{
				
			}
			else
			{
				
			}
		});
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("dozerArrive", "_dozerArrive");
		_dozerArrive = false;
		nameMap.set("dozerClick", "_dozerClick");
		_dozerClick = false;
		nameMap.set("points", "_points");
		_points = 0.0;
		nameMap.set("gameOverShown", "_gameOverShown");
		_gameOverShown = false;
		nameMap.set("tutorialShown", "_tutorialShown");
		_tutorialShown = false;
		nameMap.set("UITutorial", "_UITutorial");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_gameOverShown = false;
		propertyChanged("_gameOverShown", _gameOverShown);
		_tutorialShown = false;
		propertyChanged("_tutorialShown", _tutorialShown);
		Engine.engine.setGameAttribute("gameOver", false);
		getActor(1).setAnimation("" + "Animation Up");
		runLater(1000 * 0.5, function(timeTask:TimedTask):Void
		{
			getActor(1).setAnimation("" + "Animation Up");
		}, null);
		loopSoundOnChannel(getSound(103), Std.int(5));
		setVolumeForAllSounds(20/100);
		if(!(_tutorialShown))
		{
			_tutorialShown = true;
			propertyChanged("_tutorialShown", _tutorialShown);
			_customEvent_tutorial();
		}
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(8),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(104),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(15),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				getActor(5).growTo(100/100, Engine.engine.getGameAttribute("playerHealth")/100, 0, Linear.easeNone);
				if((!(_gameOverShown) && (Engine.engine.getGameAttribute("playerHealth") < 0)))
				{
					/* updating No Health */
					_gameOverShown = true;
					propertyChanged("_gameOverShown", _gameOverShown);
					Engine.engine.setGameAttribute("gameOver", true);
					Engine.engine.setGameAttribute("spawnThings", false);
					_customEvent_gameOverIU();
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(10),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				/* game stats */
				g.setFont(getFont(136));
				g.drawString("" + Engine.engine.getGameAttribute("canCollected"), 140, 7);
				g.drawString("" + Engine.engine.getGameAttribute("bottleColleted"), 110, 7);
				g.setFont(getFont(135));
				g.drawString("" + Engine.engine.getGameAttribute("flag"), 150, 150);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(12),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}