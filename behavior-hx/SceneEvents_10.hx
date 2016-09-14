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



class SceneEvents_10 extends SceneScript
{
	public var _enoughCans:Bool;
	public var _enoughBottles:Bool;
	public var _clicked:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_goBack():Void
	{
		switchScene(GameModel.get().scenes.get(8).getID(), null, createCrossfadeTransition(0.1));
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("enoughCans", "_enoughCans");
		_enoughCans = false;
		nameMap.set("enoughBottles", "_enoughBottles");
		_enoughBottles = false;
		nameMap.set("clicked", "_clicked");
		_clicked = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_clicked = false;
		propertyChanged("_clicked", _clicked);
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(0), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				_clicked = true;
				propertyChanged("_clicked", _clicked);
				_enoughBottles = true;
				propertyChanged("_enoughBottles", _enoughBottles);
				_enoughCans = true;
				propertyChanged("_enoughCans", _enoughCans);
				if(((Engine.engine.getGameAttribute("gameCans") > 200) && (Engine.engine.getGameAttribute("gameBottles") > 250)))
				{
					switchScene(GameModel.get().scenes.get(9).getID(), null, createCrossfadeTransition(0.3));
				}
				else if(((200 > Engine.engine.getGameAttribute("gameCans")) && (200 > Engine.engine.getGameAttribute("gameBottles"))))
				{
					_enoughBottles = false;
					propertyChanged("_enoughBottles", _enoughBottles);
					_enoughCans = false;
					propertyChanged("_enoughCans", _enoughCans);
				}
				else
				{
					if((200 > Engine.engine.getGameAttribute("gameCans")))
					{
						_enoughBottles = true;
						propertyChanged("_enoughBottles", _enoughBottles);
						_enoughCans = false;
						propertyChanged("_enoughCans", _enoughCans);
					}
					else
					{
						_enoughBottles = false;
						propertyChanged("_enoughBottles", _enoughBottles);
						_enoughCans = true;
						propertyChanged("_enoughCans", _enoughCans);
					}
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(20));
				if(_clicked)
				{
					if((!(_enoughBottles) && !(_enoughCans)))
					{
						g.drawString("" + "Not enough materials", 90, 180);
					}
					else
					{
						if(!(_enoughBottles))
						{
							g.drawString("" + "Not enough Bottles", 90, 180);
						}
						else
						{
							g.drawString("" + "Not enough Cans", 90, 180);
						}
					}
				}
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(1), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				_customEvent_goBack();
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(2), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				_customEvent_goBack();
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(3), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				_customEvent_goBack();
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(4), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				_customEvent_goBack();
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}