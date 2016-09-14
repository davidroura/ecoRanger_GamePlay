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



class SceneEvents_12 extends SceneScript
{
	public var _points:Float;
	public var _trashPerCubes:Float;
	public var _aux:Float;
	public var _aux2:Float;
	public var _aux3:Float;
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("points", "_points");
		_points = 0.0;
		nameMap.set("trashPerCubes", "_trashPerCubes");
		_trashPerCubes = 0.0;
		nameMap.set("aux", "_aux");
		_aux = 0.0;
		nameMap.set("aux2", "_aux2");
		_aux2 = 0.0;
		nameMap.set("aux3", "_aux3");
		_aux3 = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_trashPerCubes = asNumber(10);
		propertyChanged("_trashPerCubes", _trashPerCubes);
		if((Engine.engine.getGameAttribute("gameBottles") > _trashPerCubes))
		{
			_aux = asNumber((Engine.engine.getGameAttribute("gameBottles") / _trashPerCubes));
			propertyChanged("_aux", _aux);
			_aux2 = asNumber(Math.floor(_aux));
			propertyChanged("_aux2", _aux2);
			_aux3 = asNumber((Engine.engine.getGameAttribute("gameBottles") % _trashPerCubes));
			propertyChanged("_aux3", _aux3);
			Engine.engine.setGameAttribute("gameCubeGlass", (Engine.engine.getGameAttribute("gameCubeGlass") + _aux2));
			Engine.engine.setGameAttribute("gameBottles", _aux3);
		}
		if((Engine.engine.getGameAttribute("gameCans") > _trashPerCubes))
		{
			_aux = asNumber((Engine.engine.getGameAttribute("gameCans") / _trashPerCubes));
			propertyChanged("_aux", _aux);
			_aux2 = asNumber(Math.floor(_aux));
			propertyChanged("_aux2", _aux2);
			_aux3 = asNumber((Engine.engine.getGameAttribute("gameCans") % _trashPerCubes));
			propertyChanged("_aux3", _aux3);
			Engine.engine.setGameAttribute("gameCubeMetal", (Engine.engine.getGameAttribute("gameCubeMetal") + _aux2));
			Engine.engine.setGameAttribute("gameCans", _aux3);
		}
		
		/* ============================ Click ============================= */
		addMousePressedListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				saveGame("mySave", function(success:Bool):Void {
					if(success)
					{
						switchScene(GameModel.get().scenes.get(2).getID(), null, createCrossfadeTransition(0));
					}
					else
					{
						
					}
				});
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}