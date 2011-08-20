package com.pdyxs.ld21.flatland
{
	import Box2D.Dynamics.b2Body;
	
	import mx.core.UIComponent;
	
	public class Entity extends UIComponent
	{
		internal var _world:World;
		public function get world():World
		{
			return _world;
		}
		
		public var toRemove:Boolean = false;
		
		protected var _body:b2Body;
		public function get body():b2Body
		{
			return _body;
		}
		
		public function get isTop():Boolean
		{
			return false;
		}
		
		public function Entity(x:int = 0, y:int = 0)
		{
			super();
			this.x = x;
			this.y = y;
		}
		
		public function begin():void
		{
		}
		
		public function createBody():void
		{
		}
		
		public function draw():void
		{
		}
		
		public function enterFrame():void
		{
			if (toRemove)
				destroy();
			synchronizeToBody();
		}
		
		override public function set rotation(value:Number):void
		{
			super.rotation = value;
			if (body != null)
				body.SetAngle(value * Math.PI / 180.0);
		}
		
		protected function synchronizeToBody():void
		{
			x = body.GetPosition().x * world.wScale;
			y = body.GetPosition().y * world.wScale;
			super.rotation = body.GetAngle() * 180.0 / Math.PI;
		}	
		
		public function end():void
		{
		}
		
		public function destroy():void
		{
			if (world != null)
				world.remove(this);
		}
			
	}
}