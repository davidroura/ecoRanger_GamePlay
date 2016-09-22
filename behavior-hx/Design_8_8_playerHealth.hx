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
	public var _playerHealth:Float;
	public var _healthFactor:Float;
	public var _lifeBar:Float;
	public var _warning:Bool;
	public var _playerBoost:Bool;
	public var _bananasPickedUp:Float;
	public var _distance:Float;
	public var _distanceMacro:Float;
	public var _distanceBy100:Float;
	public var _bonusCard:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_tookBanana():Void
	{
		Engine.engine.setGameAttribute("extraLife", 10);
		if(_playerBoost)
		{
			Engine.engine.setGameAttribute("sceneSpeed", (Engine.engine.getGameAttribute("sceneSpeed") + 5));
			Engine.engine.setGameAttribute("boosted", true);
			_bananasPickedUp = asNumber((_bananasPickedUp + 1));
			propertyChanged("_bananasPickedUp", _bananasPickedUp);
			runLater(1000 * 2, function(timeTask:TimedTask):Void
			{
				_bananasPickedUp = asNumber((_bananasPickedUp - 1));
				propertyChanged("_bananasPickedUp", _bananasPickedUp);
				Engine.engine.setGameAttribute("sceneSpeed", (Engine.engine.getGameAttribute("sceneSpeed") - 5));
				if((_bananasPickedUp == 0))
				{
					Engine.engine.setGameAttribute("boosted", false);
				}
			}, null);
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
			if((100 > (_playerHealth + Engine.engine.getGameAttribute("extraLife"))))
			{
				_playerHealth = asNumber((_playerHealth + Engine.engine.getGameAttribute("extraLife")));
				propertyChanged("_playerHealth", _playerHealth);
				Engine.engine.setGameAttribute("extraLife", 0);
			}
			else
			{
				_playerHealth = asNumber(100);
				propertyChanged("_playerHealth", _playerHealth);
			}
		}
		else if((0 > Engine.engine.getGameAttribute("extraLife")))
		{
			_playerHealth = asNumber((_playerHealth + Engine.engine.getGameAttribute("extraLife")));
			propertyChanged("_playerHealth", _playerHealth);
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
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_calculateLifeBar():Void
	{
		_lifeBar = asNumber(((_playerHealth * 100) / 100));
		propertyChanged("_lifeBar", _lifeBar);
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("playerHealth", "_playerHealth");
		_playerHealth = 0.0;
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
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_playerHealth = asNumber(100);
		propertyChanged("_playerHealth", _playerHealth);
		_healthFactor = asNumber(0.05);
		propertyChanged("_healthFactor", _healthFactor);
		Engine.engine.setGameAttribute("bottleColleted", 0);
		Engine.engine.setGameAttribute("canCollected", 0);
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
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((_playerHealth < 30))
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
				g.setFont(getFont(19));
				g.fillRoundRect(7, 447, _playerHealth, 20, 5);
				g.setFont(getFont(19));
				g.drawString("" + Engine.engine.getGameAttribute("canCollected"), 160, 10);
				g.drawString("" + Engine.engine.getGameAttribute("bottleColleted"), 180, 10);
				g.drawString("" + (("" + "Distance:") + ("" + (("" + _distanceBy100) + ("" + "mts")))), 50, 50);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(104).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(87));
				Engine.engine.setGameAttribute("bottleColleted", (Engine.engine.getGameAttribute("bottleColleted") + 1));
				recycleActor(event.otherActor);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(63).ID, getActorType(104).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				Engine.engine.setGameAttribute("bottleColleted", (Engine.engine.getGameAttribute("bottleColleted") + 1));
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
				Engine.engine.setGameAttribute("bottleColleted", (Engine.engine.getGameAttribute("bottleColleted") + 1));
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
				Engine.engine.setGameAttribute("canCollected", (Engine.engine.getGameAttribute("canCollected") + 1));
				recycleActor(event.otherActor);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(15).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(87));
				Engine.engine.setGameAttribute("canCollected", (Engine.engine.getGameAttribute("canCollected") + 1));
				recycleActor(event.otherActor);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((_playerHealth > 0))
				{
					_playerHealth = asNumber((_playerHealth - _healthFactor));
					propertyChanged("_playerHealth", _playerHealth);
					Engine.engine.setGameAttribute("sceneSpeed", (0.20 * _playerHealth));
					Engine.engine.setGameAttribute("playerHealth", _playerHealth);
					_customEvent_extraLife();
					_customEvent_calculateLifeBar();
					_customEvent_distance();
					_customEvent_bonusCard();
				}
				else
				{
					switchScene(GameModel.get().scenes.get(4).getID(), null, createCrossfadeTransition(1.5));
				}
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
				Engine.engine.setGameAttribute("bottleColleted", (Engine.engine.getGameAttribute("bottleColleted") + 1));
				recycleActor(event.otherActor);
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(1).ID, getActorType(12).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(88));
				Engine.engine.setGameAttribute("playerControl", false);
				Engine.engine.setGameAttribute("extraLife", -10);
				runLater(1000 * 0.5, function(timeTask:TimedTask):Void
				{
					recycleActor(event.otherActor);
					Engine.engine.setGameAttribute("playerControl", true);
					Engine.engine.setGameAttribute("slowMovement", true);
				}, null);
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