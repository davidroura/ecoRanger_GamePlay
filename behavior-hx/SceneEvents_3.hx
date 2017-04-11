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



class SceneEvents_3 extends SceneScript
{
	public var _recXPos:Float;
	public var _recYPos:Float;
	public var _exitGameX:Float;
	public var _exitGameY:Float;
	public var _exitGameText:String;
	public var _exitGameRegion:Region;
	public var _exitGameClicked:Bool;
	public var _exitGameFont:Font;
	public var _soundButtonFont:Font;
	public var _soundButtonClicked:Bool;
	public var _soundButtonText:String;
	public var _soundButtonX:Float;
	public var _soundButtonY:Float;
	public var _suondButtonRegion:Region;
	public var _tiltControlFont:Font;
	public var _tiltButtonClicked:Bool;
	public var _tiltButtonText:String;
	public var _tiltButtonX:Float;
	public var _tiltButtonY:Float;
	public var _tiltButtonRegion:Region;
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("recXPos", "_recXPos");
		_recXPos = 0.0;
		nameMap.set("recYPos", "_recYPos");
		_recYPos = 0.0;
		nameMap.set("exitGameX", "_exitGameX");
		_exitGameX = 0.0;
		nameMap.set("exitGameY", "_exitGameY");
		_exitGameY = 0.0;
		nameMap.set("exitGameText", "_exitGameText");
		_exitGameText = "";
		nameMap.set("exitGameRegion", "_exitGameRegion");
		nameMap.set("exitGameClicked", "_exitGameClicked");
		_exitGameClicked = false;
		nameMap.set("exitGameFont", "_exitGameFont");
		nameMap.set("soundButtonFont", "_soundButtonFont");
		nameMap.set("soundButtonClicked", "_soundButtonClicked");
		_soundButtonClicked = false;
		nameMap.set("soundButtonText", "_soundButtonText");
		_soundButtonText = "";
		nameMap.set("soundButtonX", "_soundButtonX");
		_soundButtonX = 0.0;
		nameMap.set("soundButtonY", "_soundButtonY");
		_soundButtonY = 0.0;
		nameMap.set("suondButtonRegion", "_suondButtonRegion");
		nameMap.set("tiltControlFont", "_tiltControlFont");
		nameMap.set("tiltButtonClicked", "_tiltButtonClicked");
		_tiltButtonClicked = false;
		nameMap.set("tiltButtonText", "_tiltButtonText");
		_tiltButtonText = "";
		nameMap.set("tiltButtonX", "_tiltButtonX");
		_tiltButtonX = 0.0;
		nameMap.set("tiltButtonY", "_tiltButtonY");
		_tiltButtonY = 0.0;
		nameMap.set("tiltButtonRegion", "_tiltButtonRegion");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		/* "" */ _exitGameFont = getFont(128);
		propertyChanged("_exitGameFont", _exitGameFont);
		_exitGameClicked = false;
		propertyChanged("_exitGameClicked", _exitGameClicked);
		_exitGameText = "Exit Game";
		propertyChanged("_exitGameText", _exitGameText);
		_exitGameX = asNumber(20);
		propertyChanged("_exitGameX", _exitGameX);
		_exitGameY = asNumber(100);
		propertyChanged("_exitGameY", _exitGameY);
		createBoxRegion(_exitGameX, _exitGameY, _exitGameFont.font.getTextWidth(_exitGameText)/Engine.SCALE, _exitGameFont.getHeight()/Engine.SCALE);
		_exitGameRegion = getLastCreatedRegion();
		propertyChanged("_exitGameRegion", _exitGameRegion);
		/* "" */ _soundButtonFont = getFont(128);
		propertyChanged("_soundButtonFont", _soundButtonFont);
		_soundButtonClicked = true;
		propertyChanged("_soundButtonClicked", _soundButtonClicked);
		_soundButtonText = "Turn Off Volume";
		propertyChanged("_soundButtonText", _soundButtonText);
		_soundButtonX = asNumber(20);
		propertyChanged("_soundButtonX", _soundButtonX);
		_soundButtonY = asNumber(150);
		propertyChanged("_soundButtonY", _soundButtonY);
		createBoxRegion(_soundButtonX, _soundButtonY, _soundButtonFont.font.getTextWidth(_soundButtonText)/Engine.SCALE, _soundButtonFont.getHeight()/Engine.SCALE);
		_suondButtonRegion = getLastCreatedRegion();
		propertyChanged("_suondButtonRegion", _suondButtonRegion);
		/* "" */ _tiltControlFont = getFont(128);
		propertyChanged("_tiltControlFont", _tiltControlFont);
		_tiltButtonClicked = Engine.engine.getGameAttribute("accelerometerControl");
		propertyChanged("_tiltButtonClicked", _tiltButtonClicked);
		_tiltButtonText = "Tilt On";
		propertyChanged("_tiltButtonText", _tiltButtonText);
		if(Engine.engine.getGameAttribute("accelerometerControl"))
		{
			_tiltButtonText = "Tilt Off";
			propertyChanged("_tiltButtonText", _tiltButtonText);
		}
		_tiltButtonX = asNumber(20);
		propertyChanged("_tiltButtonX", _tiltButtonX);
		_tiltButtonY = asNumber(200);
		propertyChanged("_tiltButtonY", _tiltButtonY);
		createBoxRegion(_tiltButtonX, _tiltButtonY, _tiltControlFont.font.getTextWidth(_tiltButtonText)/Engine.SCALE, _tiltControlFont.getHeight()/Engine.SCALE);
		_tiltButtonRegion = getLastCreatedRegion();
		propertyChanged("_tiltButtonRegion", _tiltButtonRegion);
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.fillColor = Utils.getColorRGB(51,51,51);
				_recXPos = asNumber(68);
				propertyChanged("_recXPos", _recXPos);
				if(Engine.engine.getGameAttribute("accelerometerControl"))
				{
					_recYPos = asNumber(230);
					propertyChanged("_recYPos", _recYPos);
				}
				else
				{
					_recYPos = asNumber(266);
					propertyChanged("_recYPos", _recYPos);
				}
				g.fillRect(_recXPos, _recYPos, 17, 18);
				/* "" */ g.setFont(_exitGameFont);
				g.drawString("" + _exitGameText, _exitGameX, _exitGameY);
				/* "" */ g.setFont(_soundButtonFont);
				g.drawString("" + _soundButtonText, _soundButtonX, _soundButtonY);
				/* "" */ g.setFont(_tiltControlFont);
				g.drawString("" + _tiltButtonText, _tiltButtonX, _tiltButtonY);
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(_exitGameRegion, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				exitGame();
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(_suondButtonRegion, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				if(_soundButtonClicked)
				{
					_soundButtonClicked = false;
					propertyChanged("_soundButtonClicked", _soundButtonClicked);
					_soundButtonText = "Turn On Volume";
					propertyChanged("_soundButtonText", _soundButtonText);
					_soundButtonFont = getFont(128);
					propertyChanged("_soundButtonFont", _soundButtonFont);
					setVolumeForAllSounds(0/100);
					Engine.engine.setGameAttribute("game_volumen", false);
				}
				else
				{
					_soundButtonClicked = true;
					propertyChanged("_soundButtonClicked", _soundButtonClicked);
					_soundButtonText = "Turn Off Volume";
					propertyChanged("_soundButtonText", _soundButtonText);
					_soundButtonFont = getFont(128);
					propertyChanged("_soundButtonFont", _soundButtonFont);
					setVolumeForAllSounds(100/100);
					Engine.engine.setGameAttribute("game_volumen", true);
				}
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(_tiltButtonRegion, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				if(_tiltButtonClicked)
				{
					_tiltButtonClicked = false;
					propertyChanged("_tiltButtonClicked", _tiltButtonClicked);
					Engine.engine.setGameAttribute("accelerometerControl", false);
					_tiltButtonText = "Tilt On";
					propertyChanged("_tiltButtonText", _tiltButtonText);
				}
				else
				{
					_tiltButtonClicked = true;
					propertyChanged("_tiltButtonClicked", _tiltButtonClicked);
					Engine.engine.setGameAttribute("accelerometerControl", true);
					_tiltButtonText = "Tilt Off";
					propertyChanged("_tiltButtonText", _tiltButtonText);
				}
			}
		});
		
		/* ============================ Swipe ============================= */
		addSwipeListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && Input.swipedLeft)
			{
				switchScene(GameModel.get().scenes.get(2).getID(), null, createSlideRightTransition(0.3));
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(1), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				Engine.engine.setGameAttribute("accelerometerControl", true);
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(2), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				Engine.engine.setGameAttribute("accelerometerControl", false);
			}
		});
		
		/* ========================== On Region =========================== */
		addMouseOverActorListener(getRegion(0), function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 1 == mouseState)
			{
				switchScene(GameModel.get().scenes.get(2).getID(), null, createSlideRightTransition(0.3));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}