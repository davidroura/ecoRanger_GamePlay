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



class SceneEvents_17 extends SceneScript
{
	public var _listCount:Float;
	public var _position:Float;
	public var _xPosition:Float;
	public var _yPosition:Float;
	public var _yCount:Float;
	public var _xCount:Float;
	public var _cardSelected:String;
	public var _show:String;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_createAndSelect():Void
	{
		createRecycledActor(getActorType(165), _xPosition, _yPosition, Script.FRONT);
		getLastCreatedActor().setAnimation("" + Engine.engine.getGameAttribute("list_funFact")[Std.int(_position)]);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_setVars():Void
	{
		_xCount = asNumber(0);
		propertyChanged("_xCount", _xCount);
		_position = asNumber(0);
		propertyChanged("_position", _position);
		_listCount = asNumber(Engine.engine.getGameAttribute("list_funFact").length);
		propertyChanged("_listCount", _listCount);
		_yPosition = asNumber(60);
		propertyChanged("_yPosition", _yPosition);
		_xPosition = asNumber(10);
		propertyChanged("_xPosition", _xPosition);
		_show = "nada";
		propertyChanged("_show", _show);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_moveX():Void
	{
		_xCount = asNumber((_xCount + 1));
		propertyChanged("_xCount", _xCount);
		_xPosition = asNumber(((_xCount * 100) + 10));
		propertyChanged("_xPosition", _xPosition);
		_position = asNumber((_position + 1));
		propertyChanged("_position", _position);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_resetXmoveY():Void
	{
		_xCount = asNumber(0);
		propertyChanged("_xCount", _xCount);
		_yPosition = asNumber((_yPosition + 100));
		propertyChanged("_yPosition", _yPosition);
		_xPosition = asNumber(((_xCount * 100) + 10));
		propertyChanged("_xPosition", _xPosition);
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("listCount", "_listCount");
		_listCount = 0.0;
		nameMap.set("position", "_position");
		_position = 0.0;
		nameMap.set("xPosition", "_xPosition");
		_xPosition = 0.0;
		nameMap.set("yPosition", "_yPosition");
		_yPosition = 0.0;
		nameMap.set("yCount", "_yCount");
		_yCount = 0.0;
		nameMap.set("xCount", "_xCount");
		_xCount = 0.0;
		nameMap.set("cardSelected", "_cardSelected");
		_cardSelected = "";
		nameMap.set("show", "_show");
		_show = "";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_customEvent_setVars();
		while(!((_listCount <= _position)))
		{
			_customEvent_createAndSelect();
			_customEvent_moveX();
			if((0 == (_position % 3)))
			{
				_customEvent_resetXmoveY();
			}
		}
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(135));
				g.drawString("" + _show, 100, 100);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}