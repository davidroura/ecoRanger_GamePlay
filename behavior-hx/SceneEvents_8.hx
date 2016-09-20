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



class SceneEvents_8 extends SceneScript
{
	public var _itemY:Float;
	public var _itemNameX:Float;
	public var _itemMetalX:Float;
	public var _itemGlassX:Float;
	public var _dozerMetal:Float;
	public var _dozerGlass:Float;
	public var _dozerPlastic:Float;
	public var _dozerName:String;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_addItemY():Void
	{
		
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_declareVariables():Void
	{
		_itemY = asNumber(60);
		propertyChanged("_itemY", _itemY);
		_itemNameX = asNumber(52);
		propertyChanged("_itemNameX", _itemNameX);
		_itemMetalX = asNumber(195);
		propertyChanged("_itemMetalX", _itemMetalX);
		_itemGlassX = asNumber(260);
		propertyChanged("_itemGlassX", _itemGlassX);
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("itemY", "_itemY");
		_itemY = 0.0;
		nameMap.set("itemNameX", "_itemNameX");
		_itemNameX = 0.0;
		nameMap.set("itemMetalX", "_itemMetalX");
		_itemMetalX = 0.0;
		nameMap.set("itemGlassX", "_itemGlassX");
		_itemGlassX = 0.0;
		nameMap.set("dozerMetal", "_dozerMetal");
		_dozerMetal = 0.0;
		nameMap.set("dozerGlass", "_dozerGlass");
		_dozerGlass = 0.0;
		nameMap.set("dozerPlastic", "_dozerPlastic");
		_dozerPlastic = 0.0;
		nameMap.set("dozerName", "_dozerName");
		_dozerName = "";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_dozerMetal = asNumber(50);
		propertyChanged("_dozerMetal", _dozerMetal);
		_dozerGlass = asNumber(50);
		propertyChanged("_dozerGlass", _dozerGlass);
		_dozerPlastic = asNumber(0);
		propertyChanged("_dozerPlastic", _dozerPlastic);
		_dozerName = "Dozer Strength";
		propertyChanged("_dozerName", _dozerName);
		_customEvent_declareVariables();
		
		/* ============================ Swipe ============================= */
		addSwipeListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && Input.swipedRight)
			{
				vibrate(0.2);
				switchScene(GameModel.get().scenes.get(7).getID(), null, createSlideLeftTransition(0.3));
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_customEvent_declareVariables();
				g.setFont(getFont(54));
				g.drawString("" + _dozerName, _itemNameX, _itemY);
				g.drawString("" + _dozerMetal, _itemMetalX, _itemY);
				g.drawString("" + _dozerGlass, _itemGlassX, _itemY);
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(0), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				switchScene(GameModel.get().scenes.get(13).getID(), null, createCrossfadeTransition(0));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}