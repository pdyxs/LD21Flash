package com.pdyxs.ld21.flatland.tools
{
	import flash.events.KeyboardEvent;
	
	import mx.core.UIComponent;
	
	import spark.components.Application;

	public class Input
	{
		protected static var _UP:Boolean = false;
		public static function get UP():Boolean
		{
			return _UP;
		}
		protected static var _DOWN:Boolean = false;
		public static function get DOWN():Boolean
		{
			return _DOWN;
		}
		protected static var _LEFT:Boolean = false;
		public static function get LEFT():Boolean
		{
			return _LEFT;
		}
		protected static var _RIGHT:Boolean = false;
		public static function get RIGHT():Boolean
		{
			return _RIGHT;
		}
		
		public static function setupInput(app:UIComponent):void
		{
			app.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			app.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		public static function keyDown(keyEvent:KeyboardEvent):void
		{
			if (keyEvent.keyCode == 37) _LEFT = true;
			else if (keyEvent.keyCode == 38) _UP = true;
			else if (keyEvent.keyCode == 39) _RIGHT = true;
			else if (keyEvent.keyCode == 40) _DOWN = true;
		}
		
		public static function keyUp(keyEvent:KeyboardEvent):void
		{
			if (keyEvent.keyCode == 37) _LEFT = false;
			else if (keyEvent.keyCode == 38) _UP = false;
			else if (keyEvent.keyCode == 39) _RIGHT = false;
			else if (keyEvent.keyCode == 40) _DOWN = false;
		}
	}
}