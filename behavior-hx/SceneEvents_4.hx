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



class SceneEvents_4 extends SceneScript
{
	public var _points:Float;
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("points", "_points");
		_points = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_points = asNumber((Engine.engine.getGameAttribute("bottleColleted") + Engine.engine.getGameAttribute("canCollected")));
		propertyChanged("_points", _points);
		Engine.engine.setGameAttribute("gameBottles", (Engine.engine.getGameAttribute("gameBottles") + Engine.engine.getGameAttribute("bottleColleted")));
		Engine.engine.setGameAttribute("gameCans", (Engine.engine.getGameAttribute("gameCans") + Engine.engine.getGameAttribute("canCollected")));
		if((_points > 10))
		{
			createRecycledActor(getActorType(17), 87, 167, Script.FRONT);
		}
		if((_points > 40))
		{
			createRecycledActor(getActorType(17), 139, 167, Script.FRONT);
		}
		if((_points > 60))
		{
			createRecycledActor(getActorType(17), 191, 167, Script.FRONT);
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
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(getActor(2), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				switchScene(GameModel.get().scenes.get(9).getID(), null, createCrossfadeTransition(0));
			}
		});
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(getActor(1), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				switchScene(GameModel.get().scenes.get(0).getID(), null, createCrossfadeTransition(0));
			}
		});
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(getActor(3), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				switchScene(GameModel.get().scenes.get(2).getID(), null, createCrossfadeTransition(0));
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(19));
				g.drawString("" + (("" + Engine.engine.getGameAttribute("bottleColleted")) + ("" + " bottles")), 150, 220);
				g.drawString("" + (("" + Engine.engine.getGameAttribute("canCollected")) + ("" + " cans")), 150, 250);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}