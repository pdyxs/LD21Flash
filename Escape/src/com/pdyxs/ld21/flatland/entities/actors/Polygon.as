package com.pdyxs.ld21.flatland.entities.actors
{
	import com.pdyxs.ld21.flatland.Entity;
	
	public class Polygon extends Entity
	{
		public function Polygon(x:int=0, y:int=0)
		{
			super(x, y);
		}
		
		override public function begin():void
		{
			draw();
			createBody();
		}
		
		public var lifespan:Number = 0;
		
		override public function enterFrame():void
		{
			super.enterFrame();
			lifespan += 1.0 / stage.frameRate;
		}
	}
}