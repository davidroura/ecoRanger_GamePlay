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
	public var _recyclingOver:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_randomSpawn():Void
	{
		runLater(1000 * randomFloatBetween(.2, 2), function(timeTask:TimedTask):Void
		{
			_trashType = asNumber(randomInt(Math.floor(0), Math.floor(2)));
			propertyChanged("_trashType", _trashType);
			if(((_trashType == 0) && (Engine.engine.getGameAttribute("total_cans") >= 0)))
			{
				createRecycledActor(getActorType(131), randomInt(Math.floor(10), Math.floor(100)), 5, Script.FRONT);
				Engine.engine.setGameAttribute("total_cans", (Engine.engine.getGameAttribute("total_cans") - 1));
			}
			if(((_trashType == 1) && (Engine.engine.getGameAttribute("total_glassBottles") >= 0)))
			{
				createRecycledActor(getActorType(137), randomInt(Math.floor(0), Math.floor(100)), 5, Script.FRONT);
				Engine.engine.setGameAttribute("total_glassBottles", (Engine.engine.getGameAttribute("total_glassBottles") - 1));
			}
			if(((_trashType == 2) && (Engine.engine.getGameAttribute("total_plasticBottles") >= 0)))
			{
				createRecycledActor(getActorType(139), randomInt(Math.floor(0), Math.floor(100)), 5, Script.FRONT);
				Engine.engine.setGameAttribute("total_plasticBottles", (Engine.engine.getGameAttribute("total_plasticBottles") - 1));
			}
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
		nameMap.set("recyclingOver", "_recyclingOver");
		_recyclingOver = false;
		
	}
	
	override public function init()
	{
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((((Engine.engine.getGameAttribute("total_cans") <= 0) && (Engine.engine.getGameAttribute("total_plasticBottles") <= 0)) && (Engine.engine.getGameAttribute("total_glassBottles") <= 0)))
				{
					if(!(_recyclingOver))
					{
						createRecycledActor(getActorType(175), 0, Engine.engine.getGameAttribute("screenY_mid"), Script.FRONT);
						getLastCreatedActor().setAnimation("" + "noMoreTrash");
						_recyclingOver = true;
						propertyChanged("_recyclingOver", _recyclingOver);
					}
				}
				else
				{
					if(!(_spawnWait))
					{
						_customEvent_randomSpawn();
						_spawnWait = true;
						propertyChanged("_spawnWait", _spawnWait);
					}
				}
				g.setFont(getFont(128));
				g.drawString("" + Engine.engine.getGameAttribute("total_cans"), 180, 30);
				g.drawString("" + Engine.engine.getGameAttribute("total_plasticBottles"), 180, 60);
				g.drawString("" + Engine.engine.getGameAttribute("total_glassBottles"), 180, 90);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}