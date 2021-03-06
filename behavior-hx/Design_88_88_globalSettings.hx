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



class Design_88_88_globalSettings extends SceneScript
{
	public var _ScreenDiagonal:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_gameSettings():Void
	{
		Engine.engine.setGameAttribute("sceneSpeed", 22);
		Engine.engine.setGameAttribute("lateralSpeed", 0);
		Engine.engine.setGameAttribute("gameStart", false);
		Engine.engine.setGameAttribute("spawnThings", false);
		if(Engine.engine.getGameAttribute("tutorialDone"))
		{
			Engine.engine.setGameAttribute("spawnThings", true);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_playerSettings():Void
	{
		Engine.engine.setGameAttribute("playerControl", true);
		Engine.engine.setGameAttribute("dozerPlaying", false);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_globalConstants():Void
	{
		Engine.engine.setGameAttribute("screenDiagonal", Math.sqrt((Math.pow(getScreenWidth(), 2) + Math.pow(getScreenHeight(), 2))));
		Engine.engine.setGameAttribute("screenX_mid", (getScreenWidth() / 2));
		Engine.engine.setGameAttribute("screenY_mid", (getScreenHeight() / 2));
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("Screen Diagonal", "_ScreenDiagonal");
		_ScreenDiagonal = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_customEvent_playerSettings();
		_customEvent_gameSettings();
		_customEvent_globalConstants();
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}