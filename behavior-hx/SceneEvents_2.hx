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



class SceneEvents_2 extends SceneScript
{
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		if(!(Engine.engine.getGameAttribute("musicOn")))
		{
			setVolumeForAllSounds(50/100);
			playSound(getSound(121));
			Engine.engine.setGameAttribute("musicOn", true);
		}
		saveGame("mySave", function(success:Bool):Void
		{
			
		});
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(getActor(10), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				getActor(10).growTo(95/100, 95/100, 0, Linear.easeNone);
			}
		});
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(getActor(10), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				stopAllSounds();
				Engine.engine.setGameAttribute("musicOn", false);
				getActor(10).growTo(100/100, 100/100, .02, Linear.easeNone);
				switchScene(GameModel.get().scenes.get(0).getID(), null, createCrossfadeTransition(0));
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.fillColor = Utils.getColorRGB(255,200,0);
				g.setFont(getFont(59));
				g.drawString("" + "set initial game stats", 5, 5);
				g.drawString("" + "reset power ups and resources", 5, 55);
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(1), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				Utils.clear(Engine.engine.getGameAttribute("selectedBotList"));
				Utils.clear(Engine.engine.getGameAttribute("unlockedBotList"));
				Engine.engine.getGameAttribute("unlockedBotList").push("dozey");
				Engine.engine.getGameAttribute("selectedBotList").push("dozey");
				Engine.engine.setGameAttribute("totalSelectedBots", 1);
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(2), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				Engine.engine.setGameAttribute("acceleration", .4);
				Engine.engine.setGameAttribute("boostAdd", 10);
				Engine.engine.setGameAttribute("fuelEfficiency", 1.5);
				Engine.engine.setGameAttribute("totalPlastic", 5);
				Engine.engine.setGameAttribute("totalGlass", 5);
				Engine.engine.setGameAttribute("totalAluminum", 5);
				Engine.engine.setGameAttribute("total_cans", 10);
				Engine.engine.setGameAttribute("total_plasticBottles", 10);
				Engine.engine.setGameAttribute("total_glassBottles", 10);
			}
		});
		
		/* ============================ Swipe ============================= */
		addSwipeListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && Input.swipedRight)
			{
				switchScene(GameModel.get().scenes.get(3).getID(), null, createSlideLeftTransition(0.1));
				Engine.engine.setGameAttribute("foregroundMenuCalled", false);
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(0), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				Engine.engine.setGameAttribute("foregroundMenuCalled", false);
			}
		});
		
		/* ============================ Swipe ============================= */
		addSwipeListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && Input.swipedLeft)
			{
				switchScene(GameModel.get().scenes.get(7).getID(), null, createSlideRightTransition(0.1));
				Engine.engine.setGameAttribute("foregroundMenuCalled", false);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}