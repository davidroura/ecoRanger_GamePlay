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



class SceneEvents_7 extends SceneScript
{
	public var _sfxlist:Array<Dynamic>;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_playRandomSound():Void
	{
		playSound(getSoundByName(_sfxlist[Std.int(randomInt(Math.floor(0), Math.floor(_sfxlist.length)))]));
		runLater(1000 * randomInt(Math.floor(2), Math.floor(6)), function(timeTask:TimedTask):Void
		{
			_customEvent_playRandomSound();
		}, null);
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("sfx_list", "_sfxlist");
		_sfxlist = ["UI_factory_amb_sfx_1", "UI_factory_amb_sfx_2", "UI_factory_amb_sfx_3", "UI_factory_amb_sfx_4", "UI_factory_amb_sfx_5", "UI_factory_amb_sfx_6"];
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("found_GadgetScreen", true);
		setVolumeForAllSounds(100/100);
		loopSoundOnChannel(getSound(245), Std.int(1));
		_customEvent_playRandomSound();
		
		/* ============================ Swipe ============================= */
		addSwipeListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && Input.swipedRight)
			{
				switchScene(GameModel.get().scenes.get(2).getID(), null, createSlideLeftTransition(0.3));
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
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}