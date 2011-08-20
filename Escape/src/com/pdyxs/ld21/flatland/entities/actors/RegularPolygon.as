package com.pdyxs.ld21.flatland.entities.actors
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;

	public class RegularPolygon extends Polygon
	{
		protected var numSides:int;
		
		public function RegularPolygon(x:int, y:int, sides:int, size:Number)
		{
			super(x, y);
			numSides = sides;
			width = size*2;
			height = size*2;
		}
		
		override public function begin():void
		{
			super.begin();
			var vertices:Array = new Array();
			
			var dangle:Number = (Math.PI * 2) / numSides;
			var cangle:Number = 0;
			for (var i:int = 0; i != numSides; ++i)
			{
				vertices.push(new b2Vec2(Math.cos(cangle) * width/(2 * world.wScale),
									Math.sin(cangle) * width/(2*world.wScale)));
				cangle += dangle;
			}
			
			var bdef:b2BodyDef = new b2BodyDef();
			bdef.position.Set(x / world.wScale, y / world.wScale);
			bdef.type = b2Body.b2_dynamicBody;
			bdef.angle = this.rotation * Math.PI / 180.0;
			_body = world.world.CreateBody(bdef);
			
			var shape:b2PolygonShape = 
				b2PolygonShape.AsArray(vertices, vertices.length);
			
			var fix:b2FixtureDef = new b2FixtureDef();
			fix.density = 1;
			fix.isSensor = false;
			fix.shape = shape;
			
			body.CreateFixture(fix);
			body.SetUserData(this);
		}
		
		override public function draw():void
		{
			super.draw();
			
			graphics.clear();
			graphics.lineStyle(2.0, 0, 1);
			
			var dangle:Number = (Math.PI * 2) / numSides;
			var cangle:Number = 0;
			for (var i:int = 0; i != numSides; ++i)
			{
				if (i == 0)
					graphics.moveTo(Math.cos(cangle) * width/2, Math.sin(cangle) * width/2);
				else
					graphics.lineTo(Math.cos(cangle) * width/2, Math.sin(cangle) * width/2);
				cangle += dangle;
			}
			graphics.lineTo(Math.cos(cangle) * width/2, Math.sin(cangle) * width/2);
		}
	}
}