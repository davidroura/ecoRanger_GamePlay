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



class Design_156_156_playerHealthAndVelocity extends SceneScript
{
	public var _healthFactor:Float;
	public var _lifeBar:Float;
	public var _warning:Bool;
	public var _playerBoost:Bool;
	public var _bananasPickedUp:Float;
	public var _distance:Float;
	public var _distanceMacro:Float;
	public var _distanceBy100:Float;
	public var _bonusCard:Bool;
	public var _endUICreated:Bool;
	public var _points:Float;
	public var _rockCollision:Bool;
	public var _boostSpeed:Float;
	public var _distanceTree:Float;
	public var _distanceLife:Float;
	public var _levelDistance:Float;
	public var _card:Float;
	public var _cardName:String;
	public var _currentSpeed:Float;
	public var _funFactCard:Actor;
	public var _TopSpeedAcceleration:Float;
	public var _initialSpeed:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_play():Void
	{
		Engine.engine.setGameAttribute("flag", "playerHealth");
		/* if normal gameplay */
		if(Engine.engine.getGameAttribute("tutorialDone"))
		{
			if((Engine.engine.getGameAttribute("playerHealth") > 0))
			{
				Engine.engine.setGameAttribute("playerDefaultSpeed", (_initialSpeed + (Engine.engine.getGameAttribute("playerDistance") * _TopSpeedAcceleration)));
				_customEvent_distance();
				if(!(Engine.engine.getGameAttribute("gadgetPower")))
				{
					Engine.engine.setGameAttribute("playerHealth", (Engine.engine.getGameAttribute("playerHealth") - (_healthFactor * Engine.engine.getGameAttribute("fuelEfficiency"))));
				}
				/* gadget power slows down time */
				if(Engine.engine.getGameAttribute("gadgetPower2"))
				{
					Engine.engine.setGameAttribute("sceneSpeed", 45);
				}
				else
				{
					/* banana boost */
					if((0 <= Engine.engine.getGameAttribute("boostSpeed")))
					{
						Engine.engine.setGameAttribute("boostSpeed", (Engine.engine.getGameAttribute("boostSpeed") - .03));
					}
					/* normal Speed */
					if((Engine.engine.getGameAttribute("sceneSpeed") <= Engine.engine.getGameAttribute("playerDefaultSpeed")))
					{
						Engine.engine.setGameAttribute("sceneSpeed", (Engine.engine.getGameAttribute("sceneSpeed") + (Engine.engine.getGameAttribute("acceleration") + (Engine.engine.getGameAttribute("boostSpeed") * (Engine.engine.getGameAttribute("sceneSpeed") / Engine.engine.getGameAttribute("playerDefaultSpeed"))))));
					}
					else
					{
						Engine.engine.setGameAttribute("sceneSpeed", (Engine.engine.getGameAttribute("playerDefaultSpeed") + Engine.engine.getGameAttribute("boostSpeed")));
					}
					if((Engine.engine.getGameAttribute("playerHealth") <= 25))
					{
						Engine.engine.setGameAttribute("sceneSpeed", ((1.32 * Engine.engine.getGameAttribute("playerHealth")) + Engine.engine.getGameAttribute("boostSpeed")));
					}
				}
				_customEvent_extraLife();
				_customEvent_level();
			}
			else
			{
				Engine.engine.setGameAttribute("spawnThings", false);
				Engine.engine.setGameAttribute("sceneSpeed", 0);
			}
		}
		_rockCollision = false;
		propertyChanged("_rockCollision", _rockCollision);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dropFunFactCard():Void
	{
		createRecycledActor(getActorType(165), 100, 100, Script.FRONT);
		getLastCreatedActor().setAnimation("" + _cardName);
		_funFactCard = getLastCreatedActor();
		propertyChanged("_funFactCard", _funFactCard);
		_customEvent_paused();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_paused():Void
	{
		Engine.engine.setGameAttribute("game_paused", true);
		_currentSpeed = asNumber(Engine.engine.getGameAttribute("sceneSpeed"));
		propertyChanged("_currentSpeed", _currentSpeed);
		Engine.engine.setGameAttribute("sceneSpeed", 0);
		setScrollSpeedForBackground(1, "" + "bgLong", 0, 0);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_unpaused():Void
	{
		Engine.engine.setGameAttribute("game_paused", false);
		Engine.engine.setGameAttribute("sceneSpeed", _currentSpeed);
		setScrollSpeedForBackground(1, "" + "bgLong", 0, 10);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_extraLife():Void
	{
		if((Engine.engine.getGameAttribute("extraLife") > 0))
		{
			if((100 > (Engine.engine.getGameAttribute("playerHealth") + Engine.engine.getGameAttribute("extraLife"))))
			{
				Engine.engine.setGameAttribute("playerHealth", (Engine.engine.getGameAttribute("playerHealth") + Engine.engine.getGameAttribute("extraLife")));
			}
			else
			{
				Engine.engine.setGameAttribute("playerHealth", 100);
			}
		}
		Engine.engine.setGameAttribute("extraLife", 0);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_distance():Void
	{
		_distance = asNumber((_distance + (0.01 * Engine.engine.getGameAttribute("sceneSpeed"))));
		propertyChanged("_distance", _distance);
		_distanceMacro = asNumber(Math.floor((_distance / 100)));
		propertyChanged("_distanceMacro", _distanceMacro);
		_distanceBy100 = asNumber((_distanceMacro * 100));
		propertyChanged("_distanceBy100", _distanceBy100);
		Engine.engine.setGameAttribute("playerDistance", Math.floor(_distance));
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_level():Void
	{
		if((!(_levelDistance == Engine.engine.getGameAttribute("playerDistance")) && ((Engine.engine.getGameAttribute("playerDistance") % 80) == 0)))
		{
			Engine.engine.setGameAttribute("level", (Engine.engine.getGameAttribute("level") + 1));
			_levelDistance = asNumber(Engine.engine.getGameAttribute("playerDistance"));
			propertyChanged("_levelDistance", _levelDistance);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_tookBanana():Void
	{
		Engine.engine.setGameAttribute("extraLife", 27);
		Engine.engine.setGameAttribute("boosted", true);
		runLater(1000 * 2, function(timeTask:TimedTask):Void
		{
			Engine.engine.setGameAttribute("boosted", false);
		}, null);
		/* if boost isn't maxed add banana boost */
		if((Engine.engine.getGameAttribute("boostSpeed") < 25))
		{
			if(_playerBoost)
			{
				Engine.engine.setGameAttribute("boostSpeed", (Engine.engine.getGameAttribute("boostSpeed") + Engine.engine.getGameAttribute("boostAdd")));
			}
		}
		else
		{
			Engine.engine.setGameAttribute("boostSpeed", 30);
		}
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("healthFactor", "_healthFactor");
		_healthFactor = 0.0;
		nameMap.set("lifeBar", "_lifeBar");
		_lifeBar = 0.0;
		nameMap.set("warning", "_warning");
		_warning = false;
		nameMap.set("playerBoost", "_playerBoost");
		_playerBoost = false;
		nameMap.set("bananasPickedUp", "_bananasPickedUp");
		_bananasPickedUp = 0.0;
		nameMap.set("distance", "_distance");
		_distance = 0.0;
		nameMap.set("distanceMacro", "_distanceMacro");
		_distanceMacro = 0.0;
		nameMap.set("distanceBy100", "_distanceBy100");
		_distanceBy100 = 0.0;
		nameMap.set("bonusCard", "_bonusCard");
		_bonusCard = false;
		nameMap.set("endUI_Created", "_endUICreated");
		_endUICreated = false;
		nameMap.set("points", "_points");
		_points = 0.0;
		nameMap.set("rockCollision", "_rockCollision");
		_rockCollision = false;
		nameMap.set("boostSpeed", "_boostSpeed");
		_boostSpeed = 0.0;
		nameMap.set("distanceTree", "_distanceTree");
		_distanceTree = 0.0;
		nameMap.set("distanceLife", "_distanceLife");
		_distanceLife = 0.0;
		nameMap.set("levelDistance", "_levelDistance");
		_levelDistance = 0.0;
		nameMap.set("card", "_card");
		_card = 0.0;
		nameMap.set("cardName", "_cardName");
		_cardName = "";
		nameMap.set("currentSpeed", "_currentSpeed");
		_currentSpeed = 0.0;
		nameMap.set("funFactCard", "_funFactCard");
		nameMap.set("TopSpeedAcceleration", "_TopSpeedAcceleration");
		_TopSpeedAcceleration = 0;
		nameMap.set("initialSpeed", "_initialSpeed");
		_initialSpeed = 0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		/* How much distance affects topspeed. The higher the faster the topspeed will increase */
		_TopSpeedAcceleration = asNumber(.015);
		propertyChanged("_TopSpeedAcceleration", _TopSpeedAcceleration);
		_initialSpeed = asNumber(23);
		propertyChanged("_initialSpeed", _initialSpeed);
		_healthFactor = asNumber(0.045);
		propertyChanged("_healthFactor", _healthFactor);
		Engine.engine.setGameAttribute("collected_glassBottle", 0);
		Engine.engine.setGameAttribute("playerHealth", 100);
		Engine.engine.setGameAttribute("collected_cans", 0);
		Engine.engine.setGameAttribute("extraLife", 0);
		_warning = false;
		propertyChanged("_warning", _warning);
		_playerBoost = true;
		propertyChanged("_playerBoost", _playerBoost);
		_bananasPickedUp = asNumber(0);
		propertyChanged("_bananasPickedUp", _bananasPickedUp);
		_distance = asNumber(0);
		propertyChanged("_distance", _distance);
		_rockCollision = false;
		propertyChanged("_rockCollision", _rockCollision);
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(Engine.engine.getGameAttribute("debugText"))
				{
					g.setFont(getFont(114));
					g.drawString("" + Engine.engine.getGameAttribute("sceneSpeed"), 100, 100);
				}
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(15).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(87));
				Engine.engine.setGameAttribute("collected_cans", (Engine.engine.getGameAttribute("collected_cans") + 1));
				recycleActor(event.otherActor);
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
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(74).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				recycleActor(event.otherActor);
				_card = asNumber((Engine.engine.getGameAttribute("ramdomUniversalNumber") + 1));
				propertyChanged("_card", _card);
				_cardName = ("" + Engine.engine.getGameAttribute("list_funFact")[Std.int(_card)]);
				propertyChanged("_cardName", _cardName);
				_cardName = StringTools.replace(("" + _cardName), ("" + "gray"), ("" + ""));
				propertyChanged("_cardName", _cardName);
				Engine.engine.getGameAttribute("list_funFact").insert(Std.int(_card), _cardName);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(8).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(87));
				Engine.engine.setGameAttribute("collected_glassBottle", (Engine.engine.getGameAttribute("collected_glassBottle") + 1));
				recycleActor(event.otherActor);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(104).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(87));
				Engine.engine.setGameAttribute("collected_PlasticBottles", (Engine.engine.getGameAttribute("collected_PlasticBottles") + 1));
				recycleActor(event.otherActor);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(12).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((!(Engine.engine.getGameAttribute("planterPower")) && !(Engine.engine.getGameAttribute("gadgetPower2"))))
				{
					Engine.engine.setGameAttribute("sceneSpeed", 0);
					setScrollSpeedForBackground(1, "" + "bgLong", Engine.engine.getGameAttribute("lateralSpeed"), Engine.engine.getGameAttribute("sceneSpeed"));
					_rockCollision = true;
					propertyChanged("_rockCollision", _rockCollision);
				}
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(145).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((!(Engine.engine.getGameAttribute("planterPower")) && !(Engine.engine.getGameAttribute("gadgetPower2"))))
				{
					if((Engine.engine.getGameAttribute("sceneSpeed") < 15))
					{
						Engine.engine.setGameAttribute("sceneSpeed", 15);
					}
					else
					{
						Engine.engine.setGameAttribute("sceneSpeed", (Engine.engine.getGameAttribute("sceneSpeed") * .85));
					}
					setScrollSpeedForBackground(1, "" + "bgLong", Engine.engine.getGameAttribute("lateralSpeed"), Engine.engine.getGameAttribute("sceneSpeed"));
					Engine.engine.setGameAttribute("spawnThings", false);
				}
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(70).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				/* see what happens if you change it to only once per collision */
				if(!(Engine.engine.getGameAttribute("gadgetPower2")))
				{
					Engine.engine.setGameAttribute("boostSpeed", 0);
					Engine.engine.setGameAttribute("sceneSpeed", (Engine.engine.getGameAttribute("playerDefaultSpeed") * .3));
					setScrollSpeedForBackground(1, "" + "bgLong", Engine.engine.getGameAttribute("lateralSpeed"), Engine.engine.getGameAttribute("sceneSpeed"));
				}
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(72).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(Engine.engine.getGameAttribute("gadgetPower2")))
				{
					Engine.engine.setGameAttribute("sceneSpeed", (Engine.engine.getGameAttribute("sceneSpeed") * .3));
					setScrollSpeedForBackground(1, "" + "bgLong", Engine.engine.getGameAttribute("lateralSpeed"), Engine.engine.getGameAttribute("sceneSpeed"));
					Engine.engine.setGameAttribute("spawnThings", false);
				}
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(10).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(86));
				recycleActor(event.otherActor);
				_customEvent_tookBanana();
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}