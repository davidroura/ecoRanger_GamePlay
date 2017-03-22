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



class ActorEvents_228 extends ActorScript
{
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		runLater(1000 * 9, function(timeTask:TimedTask):Void
		{
			recycleActor(actor);
			Engine.engine.setGameAttribute("botOn", false);
		}, actor);
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(228).ID, getActorType(12).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				event.otherActor.setAnimation("" + "explode");
				runLater(1000 * 2, function(timeTask:TimedTask):Void
				{
					recycleActor(event.otherActor);
				}, actor);
				runLater(1000 * 1, function(timeTask:TimedTask):Void
				{
					Engine.engine.setGameAttribute("botOn", false);
				}, actor);
				trace("" + (("" + "Dozey Boost: ") + ("" + ("" + Engine.engine.getGameAttribute("dozeyBoost")))));
				if(Engine.engine.getGameAttribute("dozeyBoost"))
				{
					Engine.engine.setGameAttribute("boostSpeed", (Engine.engine.getGameAttribute("boostSpeed") + Engine.engine.getGameAttribute("boostAdd")));
					trace("" + (("" + "Boost: ") + ("" + ("" + Engine.engine.getGameAttribute("boostSpeed")))));
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				actor.setX((Engine.engine.getGameAttribute("playerXPos") + 5));
				actor.setY((Engine.engine.getGameAttribute("playerYPos") - Engine.engine.getGameAttribute("botOffset")));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}