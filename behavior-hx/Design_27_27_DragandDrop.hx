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



class Design_27_27_DragandDrop extends ActorScript
{
	public var _Grabbed:Bool;
	public var _XOffset:Float;
	public var _YOffset:Float;
	public var _OldX:Float;
	public var _OldY:Float;
	public var _CannotExitScreen:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Grabbed", "_Grabbed");
		_Grabbed = false;
		nameMap.set("X Offset", "_XOffset");
		_XOffset = 0.0;
		nameMap.set("Y Offset", "_YOffset");
		_YOffset = 0.0;
		nameMap.set("Old X", "_OldX");
		_OldX = 0.0;
		nameMap.set("Old Y", "_OldY");
		_OldY = 0.0;
		nameMap.set("Cannot Exit Screen", "_CannotExitScreen");
		_CannotExitScreen = true;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		actor.makeAlwaysSimulate();
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_Grabbed)
				{
					if(isMouseDown())
					{
						if(_CannotExitScreen)
						{
							_OldX = asNumber(actor.getX());
							propertyChanged("_OldX", _OldX);
							_OldY = asNumber(actor.getY());
							propertyChanged("_OldY", _OldY);
							actor.setX((getScreenX() + Math.max(0, Math.min((getScreenWidth() - (actor.getWidth())), (getMouseX() + _XOffset)))));
							actor.setY((getScreenY() + Math.max(0, Math.min((getScreenHeight() - (actor.getHeight())), (getMouseY() + _YOffset)))));
						}
						else
						{
							actor.setX(((getScreenX() + getMouseX()) + _XOffset));
							actor.setY(((getScreenY() + getMouseY()) + _YOffset));
						}
						actor.setVelocity(0, 0);
						actor.setAngularVelocity(Utils.RAD * (0));
					}
					if(isMouseReleased())
					{
						actor.setX(((getScreenX() + getMouseX()) + _XOffset));
						actor.setY(((getScreenY() + getMouseY()) + _YOffset));
						trace("" + _OldX);
						trace("" + _OldY);
						trace("" + actor.getX());
						trace("" + actor.getY());
						trace("" + Math.atan2((actor.getY() - _OldY), (actor.getX() - _OldX)));
						trace("" + Math.sqrt((Math.pow((actor.getX() - _OldX), 2) + Math.pow((actor.getY() - _OldY), 2))));
						actor.setVelocity(Utils.DEG * (Math.atan2((actor.getY() - _OldY), (actor.getX() - _OldX))), (Math.sqrt((Math.pow((actor.getX() - _OldX), 2) + Math.pow((actor.getY() - _OldY), 2))) * 3));
						_Grabbed = false;
						propertyChanged("_Grabbed", _Grabbed);
					}
				}
				else
				{
					if(actor.isMousePressed())
					{
						_XOffset = asNumber((actor.getX() - (getScreenX() + getMouseX())));
						propertyChanged("_XOffset", _XOffset);
						_YOffset = asNumber((actor.getY() - (getScreenY() + getMouseY())));
						propertyChanged("_YOffset", _YOffset);
						_Grabbed = true;
						propertyChanged("_Grabbed", _Grabbed);
					}
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_Grabbed)
				{
					if((sceneHasBehavior("Game Debugger") && asBoolean(getValueForScene("Game Debugger", "_Enabled"))))
					{
						g.strokeColor = getValueForScene("Game Debugger", "_CustomColor");
						g.strokeSize = Std.int(getValueForScene("Game Debugger", "_StrokeThickness"));
						g.translateToScreen();
						g.drawLine((_OldX - getScreenX()), (_OldY - getScreenY()), getMouseX(), getMouseY());
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}