package com.pdyxs.ld21.flatland.entities.environment
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.pdyxs.ld21.flatland.Entity;
	import com.pdyxs.ld21.flatland.entities.actors.Polygon;
	
	public class Remnant extends Polygon
	{
		protected var vertices:Array = new Array();
		protected var lvel:b2Vec2;
		protected var avel:Number;
		
		public function Remnant(vertices:Array, lvel:b2Vec2, avel:Number)
		{
			super();
			this.lvel = lvel;
			this.avel = avel;
			
			if (vertices.length == 0) return;
			x = (vertices[0] as b2Vec2).x;
			y = (vertices[0] as b2Vec2).y;
			
			for each (var v:b2Vec2 in vertices)
			{
				this.vertices.push(new b2Vec2(v.x - x, v.y-y));
			}
		}
		
		override public function begin():void
		{
			x *= world.wScale;
			y *= world.wScale;
			super.begin();
			
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
			
			body.SetLinearVelocity(lvel);
			body.SetAngularVelocity(avel);
		}
	}
}