package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flashx.textLayout.utils.CharacterUtil;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;	

	public class DC extends Sprite {
		
		//-------GLOBAL DC VARIABLES--------\\
		
		///--TO CHANGE NUMBER OF STRINGS CHANGE NUM_PROJECTILES--\\\*\
		private var NUM_PROJECTILES:uint = 3;/*
		\\\--TO CHANGE NUMBER OF STRINGS CHANGE NUM_PROJECTILES--///*/
		
		//Camera Stuff
		private var rightInnerBoundary = (stage.stageWidth / 2) + (stage.stageWidth / 4);
		private var leftInnerBoundary = (stage.stageWidth / 2) - (stage.stageWidth / 4);
		private var topInnerBoundary = (stage.stageHeight / 2) - (stage.stageHeight / 4);
		private var bottomInnerBoundary = (stage.stageHeight / 2) + (stage.stageHeight / 4);
		
		//Classes
		private var string_Emitter:String_Emitter;		
		private var messageBox:MessageBox;
		private var goal:Goal;
		
		//Array stuff 		
		private var projectiles:Array;		
		private var rect:Array;
		private var numRect:uint;			
		private var killers:Array;
		private var numKillers:uint;		
		private var messageBoxes:Array;
		
		//Point of Collision Arrays
		private var POCx:Array;
		private var POCy:Array;						
		private var isPOC:Array;
		private var currentProjectile:uint;
		private var i:uint;		
		
		//Physcis and location		
		private var shootRotation:Number;		
		private var speed:Number;
		private var cosSpeed:Number;
		private var sinSpeed:Number;
		private var variance:Number;
		private var variance2:Number;		
		
		//consts
		private const PI:Number = Math.PI;
		private const SPRING_Y:Number = 0.025 * .5;
		private const SPRING_X:Number = 0.008 * .5;
		private const FRICTION:Number = .925;
		private const GRAVITY:Number = 5 * .5;		
		private const BOUNCE:Number = -.6;
		private const MIN_WIDTH:Number = 100;
		private const MAXSPEED:Number = 26;
		private const OUTER_LIMIT:Number = 1000;
		
		//Bools && Strings && things
		private var isClicked:Boolean = false;
		private var outPutData:String = "";
		private var level:uint;
		
		public function DC() 
		{
			init();
		}
		
		//init
		private function init():void 
		{			
			//Add a string_emitter, give some variance for collision
			string_Emitter = new String_Emitter();
			addChild(string_Emitter);			
			variance = string_Emitter.radius / 2;
			variance2 = string_Emitter.radius / 2 - 4;
			
			//Add a goal
			goal = new Goal();
			addChild(goal);
			
			//Add some projectiles = to NUM_PROJECTILES
			//Add some Points of Collision for x and y = to NUM_PROJECTILES
			//Make an array of Booleans that lets me know at which POC I am pointing
			projectiles = new Array();
			POCx = new Array();
			POCy = new Array();
			isPOC = new Array();
			for(i = 0; i < NUM_PROJECTILES; i++)
			{
				var projectile:Projectile = new Projectile(5, Math.random() * 0xffffff);
				projectile.alpha = 0;
				addChild(projectile);
				projectiles.push(projectile);
				var POC:Number = (i * stage.stageWidth/(NUM_PROJECTILES + 1)) + (stage.stageWidth/(NUM_PROJECTILES + 1));
				POCx.push(POC);
				POC = 0;
				POCy.push(POC);
				var isPOCs:Boolean = false;
				isPOC.push(isPOCs);
			}
			
			//Spawns all objects for Level1
			SpawnLevel1();
			//Sets all object locations for Level1
			SetLevel1();
			
			//Creates a message box
			//messageBox = new MessageBox(outPutData);			
			//addChild(messageBox);
			//messageBox.y = stage.stageHeight - messageBox.height / 2;
			//messageBox.x = stage.x;										
			
			//Set up functions
			stage.addEventListener(KeyboardEvent.KEY_DOWN, spaceDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, spaceUp);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(Event.ENTER_FRAME, onLoop);		
		} //end init
		
		private function SpawnLevel1():void
		{			
			//Make Killers For Level
			numKillers = 1;
			killers = new Array();			
			for(i = 0; i < numKillers; i++)
			{
				var killer:Killer = new Killer();				
				addChild(killer);
				killers.push(killer);
			}						
			
			//Spawn some Rects to make the level
			rect = new Array();
			numRect = 5;
			//Rect[0]
			for(i = 0; i < numRect; i++)
			{
				var rects:Rect = new Rect();			
				addChild(rects);
				rect.push(rects);
			}												
		}
		
		private function SetLevel1():void
		{
			level = 1;
			//Set String Emitter Positions
			string_Emitter.x = 200;
			string_Emitter.y = 500;
			
			//Goal Positions
			goal.x = 625;
			goal.y = 100;
			
			//Set POC Values
			for(i = 0; i < NUM_PROJECTILES; i++)
			{				
				var POC:Number = (200);
				POCx[i] = POC;				
				POC = 0;
				POCy[i] = POC;
				var isPOCs:Boolean = false;
				isPOC[i] = isPOCs;
			}
			
			//Set Killer Positions
			killers[0].centerX = -1000;
			killers[0].centerY = -1000;
			killers[0].x = killers[0].centerX;
			killers[0].y = killers[0].centerY;
						
			//Set Width and Length
			rect[0].Width = 900;
			rect[1].Width = 900;
			rect[2].Height = 1200;
			rect[3].Height = 1200;
			rect[4].Height = 900;
			
			for(i = 0; i < numRect; i++)
			{
				rect[i].graphicFill();
			}
			
			//Set Rect Positions
			rect[0].x = 0; 
			rect[0].y = 0 - MIN_WIDTH;
			rect[1].x = 0; 
			rect[1].y = 1000;
			rect[2].x = 0; 
			rect[2].y = 0 - MIN_WIDTH;
			rect[3].x = 800; 
			rect[3].y = 0 - MIN_WIDTH;
			rect[4].x = 400; 
			rect[4].y = 0 - MIN_WIDTH;			
		}
		
		private function SpawnLevel2():void
		{			
			for(i = 0; i < numRect; i++)
			{
				removeChild(rect[0]);
				rect.shift();
			}			
			rect = new Array();
			numRect = 4;
			//Rect[0]
			for(i = 0; i < numRect; i++)
			{
				var rects:Rect = new Rect();			
				addChild(rects);
				rect.push(rects);
			}									
		}
		
		private function SetLevel2():void
		{
			graphics.clear();
			level = 2;
			//Set String Emitter Positions
			string_Emitter.x = 200;
			string_Emitter.y = 100;
			
			//Goal Positions
			goal.x = 200;
			goal.y = -700;
			
			//Set POC Values
			for(i = 0; i < NUM_PROJECTILES; i++)
			{				
				var POC:Number = (200);
				POCx[i] = POC;				
				POC = 500;
				POCy[i] = POC;
				var isPOCs:Boolean = false;
				isPOC[i] = isPOCs;
			}
			
			//Set Killer Positions
			killers[0].centerX = 250 - killers[0].width/2;
			killers[0].centerY = 0;
			killers[0].x = killers[0].centerX;
			killers[0].y = killers[0].centerY;
			killers[0].range = 150 - killers[0].width/2;
			killers[0].xspeed = .075;
						
			//Set Width and Length
			rect[0].Width = 500;
			rect[1].Width = 500;
			rect[2].Height = 1400;
			rect[3].Height = 1400;						
			
			for(i = 0; i < numRect; i++)
			{
				rect[i].graphicFill();
			}
			
			//Set Rect Positions
			rect[0].x = 0; 
			rect[0].y = -900;
			rect[1].x = 0; 
			rect[1].y = 400;
			rect[2].x = 400; 
			rect[2].y = -900;
			rect[3].x = 0; 
			rect[3].y = -900;						
		}
		
		private function SpawnLevel3():void
		{			
			//Make Killers For Level
			for(i = 0; i < numKillers; i++)
			{
				removeChild(killers[0]);
				killers.shift();
			}
			numKillers = 2;
			killers = new Array();			
			for(i = 0; i < numKillers; i++)
			{
				var killer:Killer = new Killer();				
				addChild(killer);
				killers.push(killer);
			}
			
			//Make Rects for level
			for(i = 0; i < numRect; i++)
			{
				removeChild(rect[0]);
				rect.shift();
			}			
			rect = new Array();
			numRect = 5;
			//Rect[0]
			for(i = 0; i < numRect; i++)
			{
				var rects:Rect = new Rect();			
				addChild(rects);
				rect.push(rects);
			}									
		}
		private function SetLevel3():void
		{
			SetLevel1();
			level = 3;
			for(i = 0; i < numKillers; i++)
			{			
			killers[i].centerY = 600;
			killers[i].x = killers[0].centerX;
			killers[i].y = killers[0].centerY;
			killers[i].range = 150 - killers[0].width/2;
			killers[i].xspeed = .075;
			}
			
			killers[0].centerX = 250 - killers[0].width/2;
			killers[1].centerX = 650 - killers[0].width/2;						
		}
		
		private function SpawnLevel4():void
		{			
			//Make Killers For Level
			for(i = 0; i < numKillers; i++)
			{
				removeChild(killers[0]);
				killers.shift();
			}
			numKillers = 1;
			killers = new Array();			
			for(i = 0; i < numKillers; i++)
			{
				var killer:Killer = new Killer();				
				addChild(killer);
				killers.push(killer);
			}
			
			//Make Rect for level
			for(i = 0; i < numRect; i++)
			{
				removeChild(rect[0]);
				rect.shift();
			}			
			rect = new Array();
			numRect = 4;
			//Rect[0]
			for(i = 0; i < numRect; i++)
			{
				var rects:Rect = new Rect();			
				addChild(rects);
				rect.push(rects);
			}
			
			//Creates a message box
			messageBox = new MessageBox(outPutData);			
			addChild(messageBox);
			messageBox.y = stage.stageHeight / 2;
			messageBox.x = stage.stageWidth / 2;
			outPutData = "END FOR NOW";
			messageBox.outPutString = outPutData;
			messageBox.changeText();
		}
		
		private function SetLevel4():void
		{
			graphics.clear();
			level = 2;
			//Set String Emitter Positions
			string_Emitter.x = 200;
			string_Emitter.y = 100;
			
			//Goal Positions
			goal.x = 200;
			goal.y = -700;
			
			//Set POC Values
			for(i = 0; i < NUM_PROJECTILES; i++)
			{				
				var POC:Number = (200);
				POCx[i] = POC;				
				POC = 500;
				POCy[i] = POC;
				var isPOCs:Boolean = false;
				isPOC[i] = isPOCs;
			}
			
			//Set Killer Positions
			killers[0].centerX = -1000;
			killers[0].centerY = -1000;
			killers[0].x = killers[0].centerX;
			killers[0].y = killers[0].centerY;
			killers[0].range = 150 - killers[0].width/2;
			killers[0].xspeed = .075;
						
			//Set Width and Length
			rect[0].Width = 700;
			rect[1].Width = 700;
			rect[2].Height = 800;
			rect[3].Height = 800;						
			
			for(i = 0; i < numRect; i++)
			{
				rect[i].graphicFill();
			}
			
			//Set Rect Positions
			rect[0].x = 0; 
			rect[0].y = -100;
			rect[1].x = 0; 
			rect[1].y = 600;
			rect[2].x = 600; 
			rect[2].y = -100;
			rect[3].x = 0; 
			rect[3].y = -100;						
		}
		
		//While a key is pressed this function tracks rotation of string_Emitter 
		//and compares it to the current strings. If String_emitter is close to a string
		//it changes a global Boolean value to effect code in onLoop();
		private function spaceDown(e:KeyboardEvent):void 
		{
			var cutRotation:Number = Math.abs(string_Emitter.rotation * PI / 180);
			var angles:Array;
			angles = new Array();
			for(i = 0; i < NUM_PROJECTILES; i++)
			{
				var dx:Number = POCx[i] - string_Emitter.x;
				var dy:Number = POCy[i] - string_Emitter.y;
				var angle:Number = Math.atan2(dy, dx);
				angles.push(Math.abs(angle));
				
				if ( cutRotation <= angles[i] + .3 && cutRotation >= angles[i] - .3 )
				{
					isPOC[i] = true;								
				}
				else
				{
					isPOC[i] = false;
				}
			}				
		}
		
		//This turns off POC Booleans when you keyUP
		private function spaceUp(e:KeyboardEvent):void 
		{
			for(i = 0; i < NUM_PROJECTILES; i++)
			{
				isPOC[i] = false;
			}			
		}
		
		//If the keydown isn't doing anything, a projectile has its speed changed
		//If keydown is up to something, a string is retracted
		private function onClick(e:MouseEvent):void {
			
			var item:Boolean = false;
			if (isPOC.some(isTrue) == true)
			{
				isClicked = true;
			}
			else
			{
				shootRotation = string_Emitter.rotation * PI / 180;
				speed = 50;
				cosSpeed = Math.cos(shootRotation) * speed;
				sinSpeed = Math.sin(shootRotation) * speed
				stage.removeEventListener(MouseEvent.CLICK, onClick);
				isClicked = false;				
			}						
		}
		
		//function is useful when you want to use myArray.some(isTrue)
		private function isTrue(element:Boolean, index:int, array:Array):Boolean {
			return (element == true);
		}
		
		//This does a lot of stuff. It handles physics, collision, and drawing lines.
		private function onLoop(e:Event):void 
		{									
			//MessageBox
			//outPutData = string_Emitter.vx.toString();
			//messageBox.outPutString = outPutData;
			//messageBox.changeText();			
			
			//string_Emitter's rotation follows mouse
			string_Emitter.dx = mouseX - string_Emitter.x;
			string_Emitter.dy = mouseY - string_Emitter.y;
			var angle:Number = Math.atan2(string_Emitter.dy, string_Emitter.dx);
			string_Emitter.rotation = angle * 180 / PI;
			
			//sets projectile to the right Projectile[currentProjectile] in the array
			var projectile:Projectile = Projectile(projectiles[currentProjectile]);					
			
			//String Emitter shoots NUM_PROJECTILES springs and physics effects string_Emitter 			
			for(i = 0; i < NUM_PROJECTILES; i++)
			{
				if (i == 0)
				{
					string_Emitter.ax = (POCx[i] - string_Emitter.x) * SPRING_X;
					string_Emitter.ay = (POCy[i] - string_Emitter.y) * SPRING_Y;
				}
				else
				{
					string_Emitter.ax += (POCx[i] - string_Emitter.x) * SPRING_X;
					string_Emitter.ay += (POCy[i] - string_Emitter.y) * SPRING_Y;
				}
			}			
			string_Emitter.vx += string_Emitter.ax;
			string_Emitter.vy += string_Emitter.ay;			
			string_Emitter.vy += GRAVITY;
			string_Emitter.vx *= FRICTION;
			string_Emitter.vy *= FRICTION;
			if (string_Emitter.vx > MAXSPEED)
			{
				string_Emitter.vx = MAXSPEED;
			}
			else
			if (string_Emitter.vx < -MAXSPEED)
			{
				(string_Emitter.vx = -MAXSPEED)
			}
			if (string_Emitter.vy > MAXSPEED)
			{
				string_Emitter.vy = MAXSPEED;
			}
			else
			if (string_Emitter.vy < -MAXSPEED)
			{
				(string_Emitter.vy = -MAXSPEED)
			}
			
			if (string_Emitter.x - string_Emitter.radius < leftInnerBoundary ||
				string_Emitter.x + string_Emitter.radius > rightInnerBoundary ||
				string_Emitter.y - string_Emitter.radius < topInnerBoundary ||
				string_Emitter.y + string_Emitter.radius > bottomInnerBoundary)
			{				
				if (string_Emitter.x - string_Emitter.radius < leftInnerBoundary)
				{
					string_Emitter.x = leftInnerBoundary + string_Emitter.radius;
					rightInnerBoundary = (stage.stageWidth / 2) + (stage.stageWidth / 4);
					for(i = 0; i < NUM_PROJECTILES; i++)
					{
						projectiles[i].x -= string_Emitter.vx;
						POCx[i] -= string_Emitter.vx;
					}
					for(i = 0; i < numRect; i++)
					{
						rect[i].x -= string_Emitter.vx;
					}
					for(i = 0; i < numKillers; i++)
					{
						killers[i].centerX -= string_Emitter.vx;
					}
					goal.x -= string_Emitter.vx;					
				}				
				else
				if (string_Emitter.x + string_Emitter.radius > rightInnerBoundary)
				{
					string_Emitter.x = rightInnerBoundary - string_Emitter.radius;
					leftInnerBoundary = (stage.stageWidth / 2) - (stage.stageWidth / 4);
					for(i = 0; i < NUM_PROJECTILES; i++)
					{
						projectiles[i].x -= string_Emitter.vx;
						POCx[i] -= string_Emitter.vx;
					}
					for(i = 0; i < numRect; i++)
					{
						rect[i].x -= string_Emitter.vx;
					}
					for(i = 0; i < numKillers; i++)
					{
						killers[i].centerX -= string_Emitter.vx;
					}
					goal.x -= string_Emitter.vx;
				}
				
				if (string_Emitter.y - string_Emitter.radius < topInnerBoundary)
				{
					string_Emitter.y = topInnerBoundary + string_Emitter.radius;
					bottomInnerBoundary = (stage.stageHeight / 2) + (stage.stageHeight / 4);
					for(i = 0; i < NUM_PROJECTILES; i++)
					{
						projectiles[i].y -= string_Emitter.vy;
						POCy[i] -= string_Emitter.vy;
					}
					for(i = 0; i < numRect; i++)
					{
						rect[i].y -= string_Emitter.vy;
					}
					for(i = 0; i < numKillers; i++)
					{
						killers[i].y -= string_Emitter.vy;
					}
					goal.y -= string_Emitter.vy;
				}		
				else
				if (string_Emitter.y + string_Emitter.radius > bottomInnerBoundary)
				{
					string_Emitter.y = bottomInnerBoundary - string_Emitter.radius;
					topInnerBoundary = (stage.stageHeight / 2) - (stage.stageHeight / 4);
					for(i = 0; i < NUM_PROJECTILES; i++)
					{
						projectiles[i].y -= string_Emitter.vy;
						POCy[i] -= string_Emitter.vy;
					}
					for(i = 0; i < numRect; i++)
					{
						rect[i].y -= string_Emitter.vy;
					}
					for(i = 0; i < numKillers; i++)
					{
						killers[i].y -= string_Emitter.vy;
					}
					goal.y -= string_Emitter.vy;
				}
			}
			else
			{			
				string_Emitter.x += string_Emitter.vx;
				string_Emitter.y += string_Emitter.vy;			
			}		
			
			//Manage killers
			
			for(i = 0; i < numKillers; i++)
			{
				killers[i].x = killers[i].centerX + Math.sin(killers[i].Angle) * killers[i].range;
				killers[i].Angle += killers[i].xspeed;
			}
			
			//Draw a string when we are shooting
			graphics.clear();
			graphics.lineStyle(1);
			graphics.moveTo(string_Emitter.x, string_Emitter.y);				
			graphics.lineTo(projectile.x, projectile.y);
			
			//projectile follows string_Emitter when not shot
			//also, if any key is down, you can delete a string
			if (speed == 0)
			{
				graphics.clear();
				projectile.x = string_Emitter.x;
				projectile.y = string_Emitter.y;				
				graphics.lineStyle(1);
				
				for(i = 0; i < NUM_PROJECTILES - 1; i++)
				{
					if (isClicked == true && isPOC[i] == true)
					{
						POCx[i] = POCx[i + 1];
						POCy[i] = POCy[i + 1];
						isClicked = false;
						isPOC[i] = false;												
					}
				}
				
				if (isClicked == true && isPOC[NUM_PROJECTILES - 1] == true)
				{
					POCx[NUM_PROJECTILES - 1] = POCx[0];
					POCy[NUM_PROJECTILES - 1] = POCy[0];
					isClicked = false;
					isPOC[NUM_PROJECTILES - 1] = false;												
				}
				
				for(i = 0; i < NUM_PROJECTILES; i++)
				{
					graphics.moveTo(string_Emitter.x, string_Emitter.y);
					graphics.lineTo(POCx[i], POCy[i]);									
				}
				
				//make string red if keydown
				for(i = 0; i < NUM_PROJECTILES; i++)
				{
					if (isPOC[i] == true)
					{						
						graphics.lineStyle(3, 0xff0000);
						graphics.moveTo(string_Emitter.x, string_Emitter.y);
						graphics.lineTo(POCx[i], POCy[i]);
					}	
				}					
			}
			
			//The string is being shot because speed !=0
			else
			{
				for(i = 0; i < NUM_PROJECTILES; i++)
				{
					graphics.moveTo(string_Emitter.x, string_Emitter.y);
					graphics.lineTo(POCx[i], POCy[i]);					
				}								
			
				//projectile moves at a uniform velocity towards mouse onClick
				projectile.vx = cosSpeed;
				projectile.vy = sinSpeed;
				projectile.x += projectile.vx;
				projectile.y += projectile.vy;			
				
				//returns projectile back to string_Emitter on collision with stage
				//this is the collision code and will need to be refitted 
				//with collision arrays when levels are implimented
				if (projectile.x > OUTER_LIMIT ||
					projectile.x < -OUTER_LIMIT) 
				{				
					if (currentProjectile == (NUM_PROJECTILES - 1))
					{
						currentProjectile = 0;						
					}
					else			
					if (currentProjectile < (NUM_PROJECTILES - 1))
					{
						currentProjectile++;						
					}			
					projectile.x = string_Emitter.x;
					projectile.y = string_Emitter.y;
					speed= 0;				
					stage.addEventListener(MouseEvent.CLICK, onClick);
				} 
				
				if (projectile.y > OUTER_LIMIT ||
					projectile.y < -OUTER_LIMIT) 
				{
					if (currentProjectile == (NUM_PROJECTILES - 1))
					{
						currentProjectile = 0;						
					}
					else			
					if (currentProjectile < (NUM_PROJECTILES - 1))
					{
						currentProjectile++;							
					}			
					projectile.x = string_Emitter.x;
					projectile.y = string_Emitter.y;
					speed= 0;				
					stage.addEventListener(MouseEvent.CLICK, onClick);					
				}
				
				for(i = 0; i < numRect; i++)
				{
					if (projectile.x > rect[i].x - projectile.radius / 2 && 
						projectile.y > rect[i].y - projectile.radius / 2 && 
						projectile.y < rect[i].y + rect[i].Height + projectile.radius / 2 &&
						projectile.x < rect[i].x + rect[i].Width + projectile.radius / 2)
					{
						if (currentProjectile == (NUM_PROJECTILES - 1))
						{
							currentProjectile = 0;						
							POCx[currentProjectile] = projectile.x;
							POCy[currentProjectile] = projectile.y;
						}
						else			
						if (currentProjectile < (NUM_PROJECTILES - 1))
						{
							currentProjectile++;						
							POCx[currentProjectile] = projectile.x;
							POCy[currentProjectile] = projectile.y;
						}			
						projectile.x = string_Emitter.x;
						projectile.y = string_Emitter.y;
						speed= 0;				
						stage.addEventListener(MouseEvent.CLICK, onClick);					
					}
				}
			}
			
			//Bounce when string_emitter hits a rect[i]
			for(i = 0; i < numRect; i++)
			{
				if (string_Emitter.x > rect[i].x - string_Emitter.radius && 
					string_Emitter.y > rect[i].y - string_Emitter.radius && 
					string_Emitter.y < rect[i].y + rect[i].Height + string_Emitter.radius &&
					string_Emitter.x < rect[i].x + rect[i].Width + string_Emitter.radius)				 
				{
					if(string_Emitter.y < rect[i].y - variance && 
					   string_Emitter.x < rect[i].x - variance)
					{
					   	string_Emitter.vy*= BOUNCE;
					   	string_Emitter.vx*= BOUNCE;
					   	string_Emitter.y = rect[i].y - string_Emitter.radius + variance2;
					   	string_Emitter.x = rect[i].x - string_Emitter.radius + variance2;					   
					   	outPutData= "Top Left";				   
					}					
					
					if(string_Emitter.y < rect[i].y - variance &&
					   string_Emitter.x > rect[i].x + rect[i].Width + variance)
					{
					 	string_Emitter.vy*= BOUNCE;
					 	string_Emitter.vx*= BOUNCE;
					 	string_Emitter.y = rect[i].y - string_Emitter.radius + variance2;
					 	string_Emitter.x = rect[i].x + rect[i].Width + string_Emitter.radius - variance2;
					 	outPutData= "Top Right";				 
					}
					
					if(string_Emitter.y > rect[i].y + rect[i].Height + variance && 
					   string_Emitter.x < rect[i].x - variance)
					{
						string_Emitter.vy*= BOUNCE;
					  	string_Emitter.vx*= BOUNCE;
					  	string_Emitter.y = rect[i].y + rect[i].Height + string_Emitter.radius - variance2;
					  	string_Emitter.x = rect[i].x - string_Emitter.radius + variance2;
					  	outPutData= "Bottom Left";				   
					}
					
					if(string_Emitter.y > rect[i].y + rect[i].Height + variance && 
					   string_Emitter.x > rect[i].x + rect[i].Width + variance)
					{
					   	string_Emitter.vy*= BOUNCE;
					  	string_Emitter.vx*= BOUNCE;
					  	string_Emitter.y = rect[i].y + rect[i].Height + string_Emitter.radius - variance2;
					  	string_Emitter.x = rect[i].x + rect[i].Width + string_Emitter.radius - variance2;					  	
					   	outPutData= "Bottom Right";
					}
					
					if(string_Emitter.y < rect[i].y && string_Emitter.x > rect[i].x &&
					   string_Emitter.x < rect[i].x + rect[i].Width)
					{
					   	string_Emitter.vy*= BOUNCE;
						string_Emitter.y = rect[i].y - string_Emitter.radius;
					   	outPutData= "Top Middle";				  
					}
					
					if(string_Emitter.y > rect[i].y + rect[i].Height && string_Emitter.x > rect[i].x && 
					   string_Emitter.x < rect[i].x + rect[i].Width)
					{
					   	string_Emitter.vy*= BOUNCE;
						string_Emitter.y = rect[i].y + rect[i].Height + string_Emitter.radius;
					   	outPutData= "Bottom Middle";				   
					}					
					
					if(string_Emitter.y < rect[i].y + rect[i].Height && string_Emitter.y > rect[i].y &&
					   string_Emitter.x < rect[i].x)
					{
						string_Emitter.vx*=BOUNCE;
						string_Emitter.x = rect[i].x - string_Emitter.radius;
						outPutData= "Left Side";
					}
					
					if(string_Emitter.y < rect[i].y + rect[i].Height && string_Emitter.y > rect[i].y &&
					   string_Emitter.x > rect[i].x + rect[i].Width)
					{
						string_Emitter.vx*=BOUNCE;
						string_Emitter.x = rect[i].x + rect[i].Width + string_Emitter.radius;
						outPutData= "Right Side";
					}
				}				
			}
			
			for(i = 0; i < numKillers; i++)
			{
				if (string_Emitter.x > killers[i].x - string_Emitter.radius && 
					string_Emitter.y > killers[i].y - string_Emitter.radius && 
					string_Emitter.y < killers[i].y + killers[i].height + string_Emitter.radius &&
					string_Emitter.x < killers[i].x + killers[i].width + string_Emitter.radius)
				{
					if (level == 1)
					{
						SetLevel1();
					}
					else
					if (level == 2)
					{
						SetLevel2();
					}
					else
					if (level == 3)
					{
						SetLevel3();
					}
				}
			}
			
			if (string_Emitter.x > goal.x - string_Emitter.radius && 
				string_Emitter.y > goal.y - string_Emitter.radius && 
				string_Emitter.y < goal.y + goal.height + string_Emitter.radius &&
				string_Emitter.x < goal.x + goal.width + string_Emitter.radius)
			{
				if (level == 1)
				{
					SpawnLevel2();
					SetLevel2();
				}
				else				
				if (level == 2)
				{
					SpawnLevel3();
					SetLevel3();
				}
				else				
				if (level == 3)
				{
					SpawnLevel4();
					SetLevel4();
				}
			}
		}
	}
}