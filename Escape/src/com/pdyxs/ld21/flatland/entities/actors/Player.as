package com.pdyxs.ld21.flatland.entities.actors
{
	import Box2D.Common.Math.b2Vec2;
	
	import com.pdyxs.ld21.flatland.tools.Input;

	public class Player extends Triangle
	{
		public const LIN_SPEED:Number = 10;
		public const ANG_SPEED:Number = 6;
		
		public function Player(x:int, y:int, isolength:Number, baselength:Number, angle:Number=0)
		{
			super(x, y, isolength, baselength, angle);
		}
		
		override public function enterFrame():void
		{
			if (Input.UP && !Input.DOWN) {
				body.SetLinearVelocity(
					new b2Vec2(LIN_SPEED*Math.sin(body.GetAngle()), 
						-LIN_SPEED*Math.cos(body.GetAngle())));
			} else if (Input.DOWN && !Input.UP) {
				body.SetLinearVelocity(
					new b2Vec2(-LIN_SPEED*Math.sin(body.GetAngle()), 
						LIN_SPEED*Math.cos(body.GetAngle())));
			} else {
				body.SetLinearVelocity(new b2Vec2(0,0));
			}
			
			if (Input.LEFT && !Input.RIGHT) {
				body.SetAngularVelocity(-ANG_SPEED);
			} else if (Input.RIGHT && !Input.LEFT) {
				body.SetAngularVelocity(ANG_SPEED);
			} else {
				body.SetAngularVelocity(0);
			}
			
			super.enterFrame();
		}
	}
}