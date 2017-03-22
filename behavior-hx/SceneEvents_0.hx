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
	public var _tutorialText:String;
	public var _tempNumber:Float;
	public var _tempDistanceNum:Float;
	public var _currentSpeed:Float;
	public var _lowFuel:Bool;
	public var _distanceHighReached:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_play():Void
	{
		Engine.engine.setGameAttribute("ramdomUniversalNumber", randomFloat());
		getActor(5).growTo(100/100, Engine.engine.getGameAttribute("playerHealth")/100, 0, Linear.easeNone);
		if((Engine.engine.getGameAttribute("playerDistance") > Engine.engine.getGameAttribute("distanceHighScore")))
		{
			if(!(_distanceHighReached))
			{
				if(!(Engine.engine.getGameAttribute("distanceHighScore") == 0))
				{
					Engine.engine.setGameAttribute("notificationText", "NEW TOP DISTANCE!");
				}
				_distanceHighReached = true;
				propertyChanged("_distanceHighReached", _distanceHighReached);
			}
			Engine.engine.setGameAttribute("distanceHighScore", Engine.engine.getGameAttribute("playerDistance"));
		}
		if((Engine.engine.getGameAttribute("playerHealth") < 20))
		{
			if(!(_lowFuel))
			{
				createRecycledActor(getActorType(175), 10, 130, Script.FRONT);
				getLastCreatedActor().setAnimation("" + "lowFuel");
				_lowFuel = true;
				propertyChanged("_lowFuel", _lowFuel);
			}
		}
		if((30 < Engine.engine.getGameAttribute("playerHealth")))
		{
			_lowFuel = false;
			propertyChanged("_lowFuel", _lowFuel);
		}
		if((!(_gameOverShown) && (Engine.engine.getGameAttribute("playerHealth") < 0)))
		{
			_gameOverShown = true;
			propertyChanged("_gameOverShown", _gameOverShown);
			Engine.engine.setGameAttribute("gameOver", true);
			_customEvent_gameOverIU();
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_tutorial():Void
	{
		if(!(Engine.engine.getGameAttribute("tutorialDone")))
		{
			createRecycledActor(getActorType(15), 200, 0, Script.FRONT);
			runLater(1000 * 1.8, function(timeTask:TimedTask):Void
			{
				Engine.engine.setGameAttribute("sceneSpeedHold", Engine.engine.getGameAttribute("sceneSpeed"));
				Engine.engine.setGameAttribute("notificationText", "GET TRASH");
			}, null);
			runLater(1000 * 4, function(timeTask:TimedTask):Void
			{
				Engine.engine.setGameAttribute("sceneSpeed", Engine.engine.getGameAttribute("sceneSpeedHold"));
			}, null);
			runLater(1000 * 5, function(timeTask:TimedTask):Void
			{
				createRecycledActor(getActorType(10), 100, 0, Script.FRONT);
			}, null);
			runLater(1000 * 5.5, function(timeTask:TimedTask):Void
			{
				Engine.engine.setGameAttribute("sceneSpeedHold", Engine.engine.getGameAttribute("sceneSpeed"));
				Engine.engine.setGameAttribute("sceneSpeed", 6);
				Engine.engine.setGameAttribute("notificationText", "COLLECT WASTE");
			}, null);
			runLater(1000 * 7.5, function(timeTask:TimedTask):Void
			{
				Engine.engine.setGameAttribute("sceneSpeed", Engine.engine.getGameAttribute("sceneSpeedHold"));
			}, null);
			runLater(1000 * 8.5, function(timeTask:TimedTask):Void
			{
				createRecycledActor(getActorType(145), 150, 0, Script.FRONT);
			}, null);
			runLater(1000 * 9, function(timeTask:TimedTask):Void
			{
				Engine.engine.setGameAttribute("sceneSpeedHold", Engine.engine.getGameAttribute("sceneSpeed"));
				Engine.engine.setGameAttribute("notificationText", "WATCH OUT!");
				Engine.engine.setGameAttribute("sceneSpeed", 6);
			}, null);
			runLater(1000 * 10, function(timeTask:TimedTask):Void
			{
				Engine.engine.setGameAttribute("sceneSpeed", Engine.engine.getGameAttribute("sceneSpeedHold"));
			}, null);
			runLater(1000 * 11.5, function(timeTask:TimedTask):Void
			{
				Engine.engine.setGameAttribute("tutorialDone", true);
			}, null);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_gameOverIU():Void
	{
		/* "put anything here that has to be initialized before next game round" */ _distanceHighReached = false;
		propertyChanged("_distanceHighReached", _distanceHighReached);
		Engine.engine.setGameAttribute("botOn", false);
		stopAllSounds();
		playSound(getSound(213));
		Engine.engine.setGameAttribute("total_glassBottles", (Engine.engine.getGameAttribute("total_glassBottles") + Engine.engine.getGameAttribute("collected_glassBottle")));
		Engine.engine.setGameAttribute("total_cans", (Engine.engine.getGameAttribute("total_cans") + Engine.engine.getGameAttribute("collected_cans")));
		Engine.engine.setGameAttribute("total_plasticBottles", (Engine.engine.getGameAttribute("total_plasticBottles") + Engine.engine.getGameAttribute("collected_PlasticBottles")));
		addBackground("UIEnd", "EndUI", Std.int(5));
		createRecycledActor(getActorType(49), 170, 290, Script.FRONT);
		createRecycledActor(getActorType(51), 50, 290, Script.FRONT);
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
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_checkAchievements():Void
	{
		if((Engine.engine.getGameAttribute("playerDistance") > 1000))
		{
			Engine.engine.getGameAttribute("achievementList")[Std.int(0)] = Engine.engine.getGameAttribute("achievementList")[Std.int(3)];
		}
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
		nameMap.set("tutorialText", "_tutorialText");
		_tutorialText = "";
		nameMap.set("tempNumber", "_tempNumber");
		_tempNumber = 0.0;
		nameMap.set("tempDistanceNum", "_tempDistanceNum");
		_tempDistanceNum = 0.0;
		nameMap.set("currentSpeed", "_currentSpeed");
		_currentSpeed = 0.0;
		nameMap.set("lowFuel", "_lowFuel");
		_lowFuel = false;
		nameMap.set("distanceHighReached", "_distanceHighReached");
		_distanceHighReached = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("currentAchievementBox", 0);
		Engine.engine.setGameAttribute("achievementsShown", new Array<Dynamic>());
		Engine.engine.getGameAttribute("achievementsShown").push(Engine.engine.getGameAttribute("achievementList")[Std.int(0)]);
		Engine.engine.getGameAttribute("achievementsShown").push(Engine.engine.getGameAttribute("achievementList")[Std.int(1)]);
		Engine.engine.getGameAttribute("achievementsShown").push(Engine.engine.getGameAttribute("achievementList")[Std.int(2)]);
		#if (flash && !air)
		Engine.engine.setGameAttribute("accelerometerControl", false);
		#end
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
		getActor(15).setAnimation("" + Engine.engine.getGameAttribute("selectedBotList")[Std.int(0)]);
		getActor(14).setAnimation("" + Engine.engine.getGameAttribute("selectedBotList")[Std.int(1)]);
		getActor(13).setAnimation("" + Engine.engine.getGameAttribute("selectedBotList")[Std.int(2)]);
		Engine.engine.setGameAttribute("tutorialDone", true);
		createRecycledActor(getActorType(248), 0, 130, Script.FRONT);
		createRecycledActor(getActorType(248), 0, 180, Script.FRONT);
		createRecycledActor(getActorType(248), 0, 230, Script.FRONT);
		
		/* ======================== Actor of Type ========================= */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(8),a.getType(),a.getGroup()))
			{
				recycleActor(a);
			}
		});
		
		/* ============================ Swipe ============================= */
		addSwipeListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && Input.swipedDown)
			{
				Engine.engine.setGameAttribute("game_paused", true);
				_currentSpeed = asNumber(Engine.engine.getGameAttribute("sceneSpeed"));
				propertyChanged("_currentSpeed", _currentSpeed);
				Engine.engine.setGameAttribute("sceneSpeed", 0);
				setScrollSpeedForBackground(1, "" + "bgLong", 0, 0);
			}
		});
		
		/* ============================ Swipe ============================= */
		addSwipeListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && Input.swipedUp)
			{
				Engine.engine.setGameAttribute("game_paused", false);
				Engine.engine.setGameAttribute("sceneSpeed", _currentSpeed);
				setScrollSpeedForBackground(1, "" + "bgLong", 0, 10);
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
				if(!(Engine.engine.getGameAttribute("game_paused")))
				{
					_customEvent_play();
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
				g.drawString("" + Engine.engine.getGameAttribute("collected_cans"), (105 - getFont(136).font.getTextWidth(Engine.engine.getGameAttribute("collected_cans"))/Engine.SCALE), 2);
				g.drawString("" + Engine.engine.getGameAttribute("collected_PlasticBottles"), (165 - getFont(136).font.getTextWidth(Engine.engine.getGameAttribute("collected_PlasticBottles"))/Engine.SCALE), 2);
				g.drawString("" + Engine.engine.getGameAttribute("collected_glassBottle"), (206 - getFont(136).font.getTextWidth(Engine.engine.getGameAttribute("collected_glassBottle"))/Engine.SCALE), 2);
				if(Engine.engine.getGameAttribute("gameOver"))
				{
					/* Game Over Stats that count up from 0 */
					g.setFont(getFont(190));
					if((_tempNumber < Engine.engine.getGameAttribute("collected_cans")))
					{
						g.drawString("" + _tempNumber, (56 - getFont(136).font.getTextWidth(("" + _tempNumber))/Engine.SCALE), 250);
					}
					else
					{
						g.drawString("" + Engine.engine.getGameAttribute("collected_cans"), (56 - getFont(136).font.getTextWidth(Engine.engine.getGameAttribute("collected_cans"))/Engine.SCALE), 250);
					}
					if((_tempNumber < Engine.engine.getGameAttribute("collected_PlasticBottles")))
					{
						g.drawString("" + _tempNumber, (156 - getFont(136).font.getTextWidth(("" + _tempNumber))/Engine.SCALE), 250);
					}
					else
					{
						g.drawString("" + Engine.engine.getGameAttribute("collected_PlasticBottles"), (156 - getFont(136).font.getTextWidth(Engine.engine.getGameAttribute("collected_PlasticBottles"))/Engine.SCALE), 250);
					}
					if((_tempNumber < Engine.engine.getGameAttribute("collected_glassBottle")))
					{
						g.drawString("" + _tempNumber, (255 - getFont(136).font.getTextWidth(("" + _tempNumber))/Engine.SCALE), 250);
					}
					else
					{
						g.drawString("" + Engine.engine.getGameAttribute("collected_glassBottle"), (255 - getFont(136).font.getTextWidth(Engine.engine.getGameAttribute("collected_glassBottle"))/Engine.SCALE), 250);
					}
					g.setFont(getFont(274));
					if((_tempDistanceNum < Engine.engine.getGameAttribute("playerDistance")))
					{
						g.drawString("" + (("" + _tempDistanceNum) + ("" + " METERS")), ((320 - getFont(274).font.getTextWidth((("" + Engine.engine.getGameAttribute("playerDistance")) + ("" + " METERS")))/Engine.SCALE) / 2), 130);
					}
					else
					{
						g.drawString("" + (("" + Engine.engine.getGameAttribute("playerDistance")) + ("" + " METERS")), ((320 - getFont(274).font.getTextWidth((("" + Engine.engine.getGameAttribute("playerDistance")) + ("" + " METERS")))/Engine.SCALE) / 2), 130);
					}
					g.setFont(getFont(201));
					g.drawString("" + (("" + "HIGHSCORE ") + ("" + Engine.engine.getGameAttribute("distanceHighScore"))), ((320 - getFont(201).font.getTextWidth((("" + "HIGHSCORE ") + ("" + Engine.engine.getGameAttribute("distanceHighScore"))))/Engine.SCALE) / 2), 175);
					/* these are the increases in the score counter */
					_tempNumber = asNumber((_tempNumber + 1));
					propertyChanged("_tempNumber", _tempNumber);
					_tempDistanceNum = asNumber((_tempDistanceNum + 9));
					propertyChanged("_tempDistanceNum", _tempDistanceNum);
				}
				/* NotificationText sets an animated form of that text in middle of screen */
				g.setFont(getFont(128));
				if(((Engine.engine.getGameAttribute("playerDistance") % 500) == 0))
				{
					if(!(Engine.engine.getGameAttribute("playerDistance") == 0))
					{
						Engine.engine.setGameAttribute("notificationText", (("" + Engine.engine.getGameAttribute("playerDistance")) + ("" + " METERS")));
					}
				}
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