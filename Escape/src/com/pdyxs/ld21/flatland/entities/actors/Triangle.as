package com.pdyxs.ld21.flatland.entities.actors
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.pdyxs.ld21.flatland.Entity;
	
	public class Triangle extends Polygon
	{
		public function Triangle(x:int, y:int, isolength:Number, baselength:Number, angle:Number = 0)
		{
			super(x, y);
			this.width = baselength;
			this.height = Math.sqrt(isolength*isolength - baselength*baselength/4);
			
			this.rotation = angle;
		}
		
		override public function createBody():void
		{
			var bdef:b2BodyDef = new b2BodyDef();
			bdef.position.Set(x / world.wScale, y / world.wScale);
			bdef.type = b2Body.b2_dynamicBody;
			bdef.angle = this.rotation * Math.PI / 180.0;
			_body = world.world.CreateBody(bdef);
			
			var shape:b2PolygonShape = 
				b2PolygonShape.AsArray(
					[new b2Vec2(0, -height/(2*world.wScale)),
					new b2Vec2(width/(2*world.wScale), height/(2*world.wScale)),
					new b2Vec2(-width/(2*world.wScale), height/(2*world.wScale))],
					3);
			
			var fix:b2FixtureDef = new b2FixtureDef();
			fix.density = 1;
			fix.isSensor = false;
			fix.shape = shape;
			
			body.CreateFixture(fix);
			body.SetUserData(this);
		}
		
		override public function draw():void
		{
			graphics.clear();
			graphics.lineStyle(2.0, 0, 1);
			graphics.moveTo(0, -height/2);
			graphics.lineTo(-width/2, height/2);
			graphics.lineTo(width/2, height/2);
			graphics.lineTo(0, -height/2);
		}
	}
}