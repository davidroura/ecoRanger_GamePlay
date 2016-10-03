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
			playSound(getSound(121));
			Engine.engine.setGameAttribute("musicOn", true);
		}
		saveGame("mySave", function(success:Bool):Void
		{
			
		});
		saveGame("mySave", function(success:Bool):Void
		{
			
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(2), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				Engine.engine.setGameAttribute("dozerStrength", (Engine.engine.getGameAttribute("dozerStrength") + 1));
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(3), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				Engine.engine.setGameAttribute("gameCubeMetal", (Engine.engine.getGameAttribute("gameCubeMetal") + 10));
				Engine.engine.setGameAttribute("gameCubeGlass", (Engine.engine.getGameAttribute("gameCubeGlass") + 10));
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(4), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				Engine.engine.setGameAttribute("gameBottles", 0);
				Engine.engine.setGameAttribute("gameCans", 0);
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(6), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				saveGame("mySave", function(success:Bool):Void
				{
					
				});
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(5), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 1 == mouseState)
			{
				Engine.engine.setGameAttribute("gameCubeMetal", 0);
				Engine.engine.setGameAttribute("gameCubeGlass", 0);
			}
		});
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(getActor(1), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				stopAllSounds();
				Engine.engine.setGameAttribute("musicOn", false);
				switchScene(GameModel.get().scenes.get(0).getID(), null, createCrossfadeTransition(0));
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.fillColor = Utils.getColorRGB(255,200,0);
				g.setFont(getFont(128));
				g.drawString("" + Engine.engine.getGameAttribute("totalPlastic"), 60, 15);
				if(Engine.engine.getGameAttribute("debugText"))
				{
					g.setFont(getFont(19));
					g.drawString("" + (("" + "dozy:") + ("" + Engine.engine.getGameAttribute("dozerStrength"))), 40, 10);
					g.drawString("" + (("" + "cans: ") + ("" + Engine.engine.getGameAttribute("gameCans"))), 140, 10);
					g.drawString("" + (("" + "Glass: ") + ("" + Engine.engine.getGameAttribute("gameCubeGlass"))), 140, 30);
					g.drawString("" + (("" + "Metal: ") + ("" + Engine.engine.getGameAttribute("gameCubeMetal"))), 40, 30);
					g.drawString("" + (("" + "Dozers:") + ("" + Engine.engine.getGameAttribute("dozerStrength"))), 40, 50);
					g.setFont(getFont(20));
					g.drawString("" + "Add dozy (test)", 40, 70);
					g.drawString("" + "Add Blocks Materials (test)", 40, 90);
					g.drawString("" + "Remove Materials (test)", 40, 110);
					g.drawString("" + "Remove Blocks Materials (test)", 40, 130);
					g.drawString("" + "save", 40, 150);
				}
			}
		});
		
		/* ============================ Swipe ============================= */
		addSwipeListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && Input.swipedRight)
			{
				switchScene(GameModel.get().scenes.get(3).getID(), null, createSlideLeftTransition(0.1));
			}
		});
		
		/* ============================ Swipe ============================= */
		addSwipeListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && Input.swipedLeft)
			{
				switchScene(GameModel.get().scenes.get(7).getID(), null, createSlideRightTransition(0.1));
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(1), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 1 == mouseState)
			{
				switchScene(GameModel.get().scenes.get(3).getID(), null, createSlideLeftTransition(0.3));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}