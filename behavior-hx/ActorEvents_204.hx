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



class ActorEvents_204 extends ActorScript
{
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		createRecycledActor(getActorType(259), 18, 65, Script.FRONT);
		createRecycledActor(getActorType(259), 290, 65, Script.FRONT);
		getLastCreatedActor().setAnimation("" + "right");
		createRecycledActor(getActorType(55), 35, 65, Script.FRONT);
		createRecycledActor(getActorType(55), 120, 65, Script.FRONT);
		getLastCreatedActor().setAnimation("" + "2Off");
		createRecycledActor(getActorType(55), 205, 65, Script.FRONT);
		getLastCreatedActor().setAnimation("" + "3Off");
		createRecycledActor(getActorType(208), 30, 210, Script.FRONT);
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(Engine.engine.getGameAttribute("foregroundMenuCalled")))
				{
					recycleActor(actor);
				}
				if(!(Engine.engine.getGameAttribute("upgradeDescription") == 0))
				{
					g.setFont(getFont(59));
					if((Engine.engine.getGameAttribute("upgradeDescription") == 1))
					{
						g.drawString("" + "FUEL EFFICIENT", 30, 130);
						g.setFont(getFont(250));
						g.drawString("" + "Use Less Fuel", 30, 150);
					}
					if((Engine.engine.getGameAttribute("upgradeDescription") == 2))
					{
						g.drawString("" + "ORGANIC BOOST", 30, 130);
						g.setFont(getFont(250));
						g.drawString("" + "More Boost From Compost", 30, 150);
					}
					if((Engine.engine.getGameAttribute("upgradeDescription") == 3))
					{
						g.drawString("" + "SUPER CHARGE", 30, 130);
						g.setFont(getFont(250));
						g.drawString("" + "Recover Faster from stops", 30, 150);
					}
					if((Engine.engine.getGameAttribute("upgradeDescription") == 4))
					{
						g.drawString("" + "IRON ARMOR", 30, 130);
						g.setFont(getFont(250));
						g.drawString("" + "Dozey hits more rocks", 30, 150);
					}
					if((Engine.engine.getGameAttribute("upgradeDescription") == 5))
					{
						g.drawString("" + "SONIC BOOST", 30, 130);
						g.setFont(getFont(250));
						g.drawString("" + "Gadget lasts twice as long", 30, 150);
					}
					if((Engine.engine.getGameAttribute("upgradeDescription") == 6))
					{
						g.drawString("" + "BULLDOZE BUILD", 30, 130);
						g.setFont(getFont(250));
						g.drawString("" + "Planter can dig longer", 30, 150);
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}