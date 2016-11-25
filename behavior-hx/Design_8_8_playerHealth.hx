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



class Design_8_8_playerHealth extends SceneScript
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
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_tookBanana():Void
	{
		Engine.engine.setGameAttribute("extraLife", 10);
		Engine.engine.setGameAttribute("boosted", true);
		runLater(1000 * 2, function(timeTask:TimedTask):Void
		{
			Engine.engine.setGameAttribute("boosted", false);
		}, null);
		/* if boost isn't maxed add banana boost */
		if((_boostSpeed < 30))
		{
			if(_playerBoost)
			{
				_boostSpeed = asNumber((_boostSpeed + 13));
				propertyChanged("_boostSpeed", _boostSpeed);
			}
		}
		else
		{
			_boostSpeed = asNumber(30);
			propertyChanged("_boostSpeed", _boostSpeed);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_bonusCard():Void
	{
		if((_distance > 600))
		{
			if(!(_bonusCard))
			{
				createRecycledActor(getActorType(74), randomInt(Math.floor(-20), Math.floor(280)), -10, Script.FRONT);
				_bonusCard = true;
				propertyChanged("_bonusCard", _bonusCard);
			}
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_extraLife():Void
	{
		if((Engine.engine.getGameAttribute("extraLife") > 0))
		{
			if((100 > (Engine.engine.getGameAttribute("playerHealth") + Engine.engine.getGameAttribute("extraLife"))))
			{
				Engine.engine.setGameAttribute("playerHealth", (Engine.engine.getGameAttribute("playerHealth") + Engine.engine.getGameAttribute("extraLife")));
				Engine.engine.setGameAttribute("extraLife", 0);
			}
			else
			{
				Engine.engine.setGameAttribute("playerHealth", 100);
			}
		}
		else if((0 > Engine.engine.getGameAttribute("extraLife")))
		{
			Engine.engine.setGameAttribute("playerHealth", (Engine.engine.getGameAttribute("playerHealth") + Engine.engine.getGameAttribute("extraLife")));
			Engine.engine.setGameAttribute("extraLife", 0);
		}
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
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("playerHealth", 100);
		_healthFactor = asNumber(0.05);
		propertyChanged("_healthFactor", _healthFactor);
		Engine.engine.setGameAttribute("collected_glassBottle", 0);
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
		_bonusCard = false;
		propertyChanged("_bonusCard", _bonusCard);
		_rockCollision = false;
		propertyChanged("_rockCollision", _rockCollision);
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((Engine.engine.getGameAttribute("playerHealth") >= 0))
				{
					if((Engine.engine.getGameAttribute("playerHealth") < 30))
					{
						if(!(_warning))
						{
							g.setFont(getFont(20));
							g.drawString("" + "Low Fuel!!!", 150, 200);
							runLater(1000 * 1, function(timeTask:TimedTask):Void
							{
								_warning = true;
								propertyChanged("_warning", _warning);
							}, null);
						}
					}
					else
					{
						_warning = false;
						propertyChanged("_warning", _warning);
					}
				}
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(104).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(87));
				Engine.engine.setGameAttribute("collected_glassBottle", (Engine.engine.getGameAttribute("collected_glassBottle") + 1));
				recycleActor(event.otherActor);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(63).ID, getActorType(104).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				Engine.engine.setGameAttribute("collected_glassBottle", (Engine.engine.getGameAttribute("collected_glassBottle") + 1));
				recycleActor(event.otherActor);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(63).ID, getActorType(12).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((Engine.engine.getGameAttribute("dozerStrengthUnits") > 0))
				{
					event.thisActor.setAnimation("" + "On");
				}
				runLater(1000 * 0.5, function(timeTask:TimedTask):Void
				{
					recycleActor(event.otherActor);
				}, null);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(63).ID, getActorType(8).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				Engine.engine.setGameAttribute("collected_glassBottle", (Engine.engine.getGameAttribute("collected_glassBottle") + 1));
				recycleActor(event.otherActor);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(63).ID, getActorType(10).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				recycleActor(event.otherActor);
				_customEvent_tookBanana();
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(63).ID, getActorType(15).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				Engine.engine.setGameAttribute("collected_cans", (Engine.engine.getGameAttribute("collected_cans") + 1));
				recycleActor(event.otherActor);
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
				Engine.engine.setGameAttribute("flag", "playerHealth");
				if((!(_rockCollision) && !(Engine.engine.getGameAttribute("gameOver"))))
				{
					Engine.engine.setGameAttribute("spawnThings", true);
				}
				/* if normal gameplay */
				if((Engine.engine.getGameAttribute("spawnThings") || Engine.engine.getGameAttribute("tutorialDone")))
				{
					if((Engine.engine.getGameAttribute("playerHealth") > 0))
					{
						if(!(Engine.engine.getGameAttribute("gadgetPower")))
						{
							Engine.engine.setGameAttribute("playerHealth", (Engine.engine.getGameAttribute("playerHealth") - (_healthFactor * Engine.engine.getGameAttribute("fuelEfficiency"))));
						}
						/* gadget power slows down time */
						if(Engine.engine.getGameAttribute("gadgetPower"))
						{
							Engine.engine.setGameAttribute("sceneSpeed", 8);
						}
						if(Engine.engine.getGameAttribute("gadgetPower2"))
						{
							Engine.engine.setGameAttribute("sceneSpeed", 55);
						}
						else
						{
							/* banana boost */
							if((0 <= _boostSpeed))
							{
								_boostSpeed = asNumber((_boostSpeed - .06));
								propertyChanged("_boostSpeed", _boostSpeed);
							}
							Engine.engine.setGameAttribute("sceneSpeed", (Math.sqrt((10 * Engine.engine.getGameAttribute("playerHealth"))) + _boostSpeed));
						}
						_customEvent_extraLife();
						_customEvent_distance();
						_customEvent_level();
						_customEvent_bonusCard();
					}
					else
					{
						Engine.engine.setGameAttribute("spawnThings", false);
						Engine.engine.setGameAttribute("sceneSpeed", 0);
						Engine.engine.setGameAttribute("gameOver", true);
					}
				}
				_rockCollision = false;
				propertyChanged("_rockCollision", _rockCollision);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(74).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				recycleActor(event.otherActor);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(63).ID, getActorType(74).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				recycleActor(event.otherActor);
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
				if(!(Engine.engine.getGameAttribute("planterPower")))
				{
					Engine.engine.setGameAttribute("sceneSpeed", 0);
					setScrollSpeedForBackground(1, "" + "bgLong", Engine.engine.getGameAttribute("lateralSpeed"), Engine.engine.getGameAttribute("sceneSpeed"));
					_rockCollision = true;
					propertyChanged("_rockCollision", _rockCollision);
					Engine.engine.setGameAttribute("spawnThings", false);
				}
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(145).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((!(Engine.engine.getGameAttribute("planterPower")) || !(Engine.engine.getGameAttribute("gadgetPower2"))))
				{
					Engine.engine.setGameAttribute("sceneSpeed", (Engine.engine.getGameAttribute("sceneSpeed") * .5));
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
				Engine.engine.setGameAttribute("sceneSpeed", (Engine.engine.getGameAttribute("sceneSpeed") * .5));
				setScrollSpeedForBackground(1, "" + "bgLong", Engine.engine.getGameAttribute("lateralSpeed"), Engine.engine.getGameAttribute("sceneSpeed"));
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