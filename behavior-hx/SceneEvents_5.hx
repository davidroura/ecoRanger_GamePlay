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



class SceneEvents_5 extends SceneScript
{
	public var _skipNews:Region;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_audobonMess():Void
	{
		_customEvent_removeAllBG();
		addBackground("audobonMessBG", "audobonMessBG", Std.int(1));
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_introHQBG():Void
	{
		_customEvent_removeAllBG();
		addBackground("introHQBG", "introHQBG", Std.int(1));
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_removeAllBG():Void
	{
		removeBackground(1, "introHQBG");
		removeBackground(1, "newsRoomBG");
		removeBackground(1, "audobonMessBG");
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("skipNews", "_skipNews");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		setVolumeForAllSounds(75/100);
		playSoundOnChannel(getSound(78), Std.int(1));
		/* after a few seconds you can switch the conversation, we will also implement an exit comfirmation notification */
		runLater(1000 * 2, function(timeTask:TimedTask):Void
		{
			Engine.engine.setGameAttribute("presentationWatched", true);
		}, null);
		runLater(1000 * 14, function(timeTask:TimedTask):Void
		{
			createRecycledActor(getActorType(253), 19, 270, Script.MIDDLE);
			getLastCreatedActor().setAnimation("" + "minibot");
		}, null);
		runLater(1000 * 14.5, function(timeTask:TimedTask):Void
		{
			recycleActor(getLastCreatedActor());
			recycleActor(getActor(2));
			createRecycledActor(getActorType(263), 0, 0, Script.FRONT);
		}, null);
		runLater(1000 * 19, function(timeTask:TimedTask):Void
		{
			recycleActor(getLastCreatedActor());
			_customEvent_introHQBG();
		}, null);
		runLater(1000 * 28, function(timeTask:TimedTask):Void
		{
			playSoundOnChannel(getSound(80), Std.int(1));
		}, null);
		runLater(1000 * 31, function(timeTask:TimedTask):Void
		{
			createRecycledActor(getActorType(269), 0, 0, Script.FRONT);
		}, null);
		runLater(1000 * 34, function(timeTask:TimedTask):Void
		{
			switchScene(GameModel.get().scenes.get(2).getID(), null, createCrossfadeTransition(1));
		}, null);
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(0), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 5 == mouseState)
			{
				if(Engine.engine.getGameAttribute("presentationWatched"))
				{
					stopSoundOnChannel(Std.int(0));
					switchScene(GameModel.get().scenes.get(2).getID(), null, createCrossfadeTransition(.2));
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}