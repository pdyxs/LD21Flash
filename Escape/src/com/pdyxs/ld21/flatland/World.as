package com.pdyxs.ld21.flatland
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.pdyxs.ld21.flatland.entities.actors.Player;
	import com.pdyxs.ld21.flatland.entities.actors.RegularPolygon;
	import com.pdyxs.ld21.flatland.entities.actors.Triangle;
	import com.pdyxs.ld21.flatland.tools.Input;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.formatters.NumberFormatter;
	
	public class World extends UIComponent
	{
		protected var entities:Vector.<Entity> = new Vector.<Entity>();
		protected var newEntities:Vector.<Entity> = new Vector.<Entity>();
		protected var removedEntities:Vector.<Entity> = new Vector.<Entity>();
		
		protected var _world:b2World = new b2World(new b2Vec2(), false);
		public function get world():b2World {
			return _world;
		}
		
		protected var world_scale:Number = 30;
		public function get wScale():Number
		{
			return world_scale;
		}
		
		public function World()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, begin);
		}
		
		public function begin(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, begin);
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			Input.setupInput(this);
			stage.focus = this;
			
			world.SetContactListener(new FlatlandContactListener);
			
			doStats();
			do_debug();
			
			add(new Triangle(400, 300, 30, 10, 60));
			add(new RegularPolygon(200, 200, 4, 30));
			add(new RegularPolygon(400, 200, 15, 30));
			add(new RegularPolygon(300, 500, 2, 40));
			add(new Player(100, 100, 30, 10, 60));
		}
		
		public function enterFrame(e:Event):void
		{
			if (entities == null) entities = new Vector.<Entity>();
			
			for each (var ent:Entity in entities)
			{
				if (ent != null)
					ent.enterFrame();
			}
			
			if (_debug)
				world.DrawDebugData();
			if (_stats)
			{
				var curTime:Number = getTimer();
				if (curTime - firstTime > 2000)
				{
					frameCount++;
					
					var format:NumberFormatter = new NumberFormatter();
					format.precision = 2;
					var fps:String = format.format(1000.0 / (curTime - lastTime));
					if (frameCount % 5 == 0)
						fpsText.text = fps + "/" + String(stage.frameRate) + " FPS";
					
					fps = format.format(1000.0 * frameCount / (curTime - firstTime - 2000));
					afpsText.text = "Avg: " + fps;
				}
				
				lastTime = curTime;
			}
			
			world.Step(1.0 / stage.frameRate, 10, 10);
			world.ClearForces();
			
			insertNewEntities();
			removeDeletedEntities();
		}
		
		public function add(e:Entity):Entity
		{
			if (e.world) return e;
			newEntities.push(e);
			e._world = this;
			return e;  
		}
		
		/**
		 * removes an entity from the world
		 */
		public function remove(e:Entity):Entity
		{
			if (e.world != this) return e;
			removedEntities.push(e);
			e._world = null;
			return e;
		}
		
		protected var topEntityCount:int = 0;
		
		/**
		 * inserts any new entities and calls their 'begin' function
		 */
		protected function insertNewEntities():void
		{
			while (newEntities.length > 0)
			{
				var e:Entity = newEntities.pop();
				entities.push(e);
				if (e.isTop)
				{
					addChild(e);
					topEntityCount++;
				} else {
					addChildAt(e, numChildren - topEntityCount);
				} 
				e.begin();
			}
		}
		
		/**
		 * removes any deleted entities and calls their 'end' function
		 */
		protected function removeDeletedEntities():void
		{
			while (removedEntities.length > 0)
			{
				var e:Entity = removedEntities.pop();
				for (var i:int = 0; i != entities.length; ++i)
				{
					if (e == entities[i])
					{
						entities.splice(i, 1);
						e.end();
						if (e.body) 
							world.DestroyBody(e.body);
						removeChild(e);
						break;
					}
				}
			}
		}
		
		//variables and objects used for stats
		protected var fpsText:Text;
		protected var afpsText:Text;
		protected var firstTime:Number;
		protected var lastTime:Number;
		protected var frameCount:uint = 0;
		protected var _stats:Boolean = false;
		/**
		 * adds stats to the display
		 */
		protected function doStats():void 
		{
			_stats = true;
			
			fpsText = new Text();
			fpsText.x = 0;
			fpsText.y = 0;
			fpsText.width = 200;
			fpsText.height = 20;
			fpsText.text = "FPS";
			lastTime = getTimer();
			addChild(fpsText);
			
			afpsText = new Text();
			afpsText.x = 0;
			afpsText.y = 15;
			afpsText.width = 200;
			afpsText.height = 20;
			afpsText.text = "Average";
			firstTime = getTimer();
			addChild(afpsText);
		}
		
		//enables debug drawing
		protected var _debug:Boolean = false;
		protected function do_debug():void
		{
			_debug = true;
			debug_draw();
		} 
		
		//debug drawing function (drawing uses box2d)
		protected function debug_draw():void
		{
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();
			addChild(debug_sprite);
			debug_draw.SetSprite(debug_sprite);
			debug_draw.SetAlpha(0.8);
			debug_draw.SetDrawScale(world_scale);
			debug_draw.SetFlags(b2DebugDraw.e_shapeBit |
				b2DebugDraw.e_jointBit);
			debug_draw.SetLineThickness(1);
			world.SetDebugDraw(debug_draw);
		}
	}
}