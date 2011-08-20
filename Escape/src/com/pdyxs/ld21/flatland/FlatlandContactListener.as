package com.pdyxs.ld21.flatland
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2PolygonContact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	
	import com.pdyxs.ld21.flatland.entities.actors.Polygon;
	import com.pdyxs.ld21.flatland.entities.environment.Remnant;
	
	import flash.display.Graphics;
	
	public class FlatlandContactListener extends b2ContactListener
	{
		public function FlatlandContactListener()
		{
			super();
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			var bodyA:b2Body = contact.GetFixtureA().GetBody();
			var bodyB:b2Body = contact.GetFixtureB().GetBody();
			
			if (bodyA.GetUserData() is Polygon &&
				bodyB.GetUserData() is Polygon)
			{
				if ((bodyA.GetUserData() as Polygon).lifespan < 2 || 
					(bodyB.GetUserData() as Polygon).lifespan < 2) return;
				
				var shapeA:b2PolygonShape = contact.GetFixtureA().GetShape() as b2PolygonShape;
				var shapeB:b2PolygonShape = contact.GetFixtureB().GetShape() as b2PolygonShape;
				
				if (contact.GetManifold().m_pointCount == 1)
				{
					var worldMani:b2WorldManifold = new b2WorldManifold();
					contact.GetWorldManifold(worldMani);
					var contactPosition:b2Vec2 = worldMani.m_points[0];
					
					var closestShape:b2Shape = null;
					var closestDist:Number = -1;
					
					for each (var vert:b2Vec2 in shapeA.GetVertices())
					{
						var vertex:b2Vec2 = new b2Vec2(
							Math.cos(bodyA.GetAngle())*vert.x - Math.sin(bodyA.GetAngle())*vert.y,
							Math.sin(bodyA.GetAngle())*vert.x + Math.cos(bodyA.GetAngle())*vert.y);
						vertex.Add(bodyA.GetPosition());
						vertex.Subtract(contactPosition);
						if (closestDist == -1 || closestDist > (vertex.LengthSquared()))
						{
							closestShape = shapeA;
							closestDist = vertex.LengthSquared();
						}
					}
					for each (var vert2:b2Vec2 in shapeB.GetVertices())
					{
						var vertex2:b2Vec2 = new b2Vec2(
							Math.cos(bodyB.GetAngle())*vert2.x - Math.sin(bodyB.GetAngle())*vert2.y,
							Math.sin(bodyB.GetAngle())*vert2.x + Math.cos(bodyB.GetAngle())*vert2.y);
						vertex2.Add(bodyB.GetPosition());
						vertex2.Subtract(contactPosition);
						if (closestDist > (vertex2.LengthSquared()))
						{
							closestShape = shapeB;
							break;
						}
					}
					
					var v1:Array = new Array();
					var v2:Array = new Array();
					var lvel:b2Vec2;
					var avel:Number;
					
					var world:World = (bodyB.GetUserData() as Entity).world;
					
					if (closestShape == shapeA)
					{
						findContactPoints(contactPosition, worldMani.m_normal, shapeB, bodyB, v1, v2);
						lvel = bodyB.GetLinearVelocity().Copy();
						avel = bodyB.GetAngularVelocity();
						(bodyB.GetUserData() as Entity).destroy();
					} else if (closestShape == shapeB)
					{
						findContactPoints(contactPosition, worldMani.m_normal, shapeA, bodyA, v1, v2);
						lvel = bodyA.GetLinearVelocity().Copy();
						avel = bodyA.GetAngularVelocity();
						(bodyA.GetUserData() as Entity).destroy();
					}
					
					if (v1 == null || v2 == null) return;
					world.add(new Remnant(v1, lvel, avel));
					world.add(new Remnant(v2, lvel, avel));
				}
			}
		}
		
		protected function findContactPoints(p:b2Vec2, v:b2Vec2, shape:b2PolygonShape, body:b2Body, v1:Array, v2:Array):void
		{
			var first:Boolean = true;
			var m1:Number = v.y - v.x;
			for (var i:int = 0; i != shape.GetVertexCount(); ++i)
			{
				var j:int = i+1;
				if (j == shape.GetVertexCount()) j = 0;
				var e:b2Vec2 = shape.GetVertices()[i].Copy();
				var f:b2Vec2 = shape.GetVertices()[j].Copy();
				transformVertex(e, body);
				transformVertex(f, body);
				var m2:Number = (f.y - e.y) / (f.x - e.x);
				
				var x:Number = (m1 * p.x - m2 * e.x + e.y - p.y) / (m1 - m2);
				var y:Number = m1*x - m1*p.x+p.y;
				
				if (first)
				{
					v1.push(e.Copy());
				} else {
					v2.push(e.Copy());
				}
				
				if (((y - e.y) * (y - f.y) <= 0) && ((x - e.x) * (x - f.x) <= 0))
				{
					if (first)
					{
						first=false;
						v1.push(new b2Vec2(x,y));
						v2.push(new b2Vec2(x,y));
					} else if (shape.GetVertexCount() > 2) {
						first = true;
						v1.push(new b2Vec2(x,y));
						v2.push(new b2Vec2(x,y));
					}
				}
			}
		}
		
		protected function transformVertex(v:b2Vec2, body:b2Body):void
		{
			v.Set(Math.cos(body.GetAngle())*v.x - Math.sin(body.GetAngle())*v.y,
				Math.sin(body.GetAngle())*v.x + Math.cos(body.GetAngle())*v.y);
			v.Add(body.GetPosition());
		}
	}
}