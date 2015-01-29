package  {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	//TWEENING IMPORTS
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.motion.easing.Back;
	import flash.events.Event;

	public class EnemySprite extends MovieClip {
		
		public var image:MovieClip;
		public var bullet:MovieClip;
		public var bulletArr:Array;
		
		//Enemy Limits
		private var leftLimit:Number;
		private var rightLimit:Number;
		private var upLimit:Number;
		private var downLimit:Number;
		
		public var stageVar:Stage;

		//ENEMY VARIABLES
		private var maxHP:Number;
		public var currHP:Number;
		public var eType:String;
		
		//enemy AI
		private var speed:Point = new Point(5, 10);
		private var dt:Number = 1.0/24;
		private var aiDirection:Number = 1;
		private var elapsedTime:Number;

		//Constructor
		public function EnemySprite(_stageVar:Stage, type:int) {
			bulletArr = new Array();
			stageVar = _stageVar;
			
			//Sets up variables depending on type of Enemy
			switch (type) {
				case 0: //Minion
					image = new M_00();
					eType = "MINION";
					//Set Health depending on Stage
					switch(Main.GameState) {
						case 1: //Phase 01
							maxHP = Constants.randomRange(10, 17);
							break;
						case 2: //Phase 02
							maxHP = Constants.randomRange(20, 35);
							break;
						case 3: //Phase 03
							maxHP = Constants.randomRange(80, 100);
							break;
					}
					
					break;
				case 1: //Boss 01
					image = new B_01();
					eType = "BOSS_01";
					//maxHP = 10;
					maxHP = Constants.randomRange(20, 30);
					break;
				case 2: //Boss 02
					image = new B_02();
					eType = "BOSS_02";
					maxHP = Constants.randomRange(100, 150);
					break;
				case 4: //Final Boss
					image = new B_F();
					eType = "BOSS_FINAL";
					maxHP = Constants.randomRange(300, 400);
					break;
				case 5://other minion
					image = new M_00();
					eType ="MINION_02"
					maxHP = Constants.randomRange(40,70);
					break;
				default: //Defaults to Ugly Player
					image = new Play();
					trace("Don't go default...");
					break;
			}
			
			currHP = maxHP;
			if(eType == "MINION_02")
			{
				image.scaleY = -1;
				image.x = 0;
				image.y = Constants.randomRange(100,200);
				upLimit = image.y - 10;
				downLimit = image.y + 10;
				leftLimit = 0;
				rightLimit = stageVar.stageWidth - image.x;
			}
			else{
				image.scaleY = -1;
				image.x = Constants.randomRange(image.width, stageVar.width - image.width);
				image.y = 0;
				leftLimit = image.x - 150;
				rightLimit = image.x + 150;
			}
			elapsedTime = 0;
		}
		
		//Update
		public function Update():void {
			//Move the Enemy	
			var enemyFrequency:Number = 3;
			elapsedTime += 1 * dt;
			var upDown:Number = 1;
			
			if(image.x < 0) { aiDirection = 1; }
			else if(image.x > stageVar.stageWidth) { aiDirection = -1; }
			
			if(aiDirection == -1 && image.x <= leftLimit) {
					aiDirection = 1; 
			}else if(aiDirection == 1 && image.x >= rightLimit) {
					aiDirection = -1;  
			}
			
			if(eType == "MINION_02")
			{
				if(image.y < 0) { upDown = 1; }
				else if(image.y > stageVar.stageWidth) { upDown = -1; }
				
				
				//Uncomment for Cats on Catnip in Phase 3
				//enemyFrequency = 1;
				image.x +=speed.x * aiDirection;
				image.y +=speed.y * Math.sin(enemyFrequency * elapsedTime);
			}
			else{
				image.x += speed.x * aiDirection;
				image.y += speed.y * dt;
			}
			
			
				
			//Move the Bullets
			for(var i:int = 0; i < bulletArr.length; i++) {
				bulletArr[i].y += 5;
				//Check if Bullets offscreen
				if(bulletArr[i].y > 688) {
					stageVar.removeChild(bulletArr[i]);
					bulletArr.splice(i, 1);
				}
			}
		}
		
		//Check Bullet Collision
		function CheckBulletCollision(eBullets:Array):void {
			for(var i:int = 0; i < eBullets.length; i++) {
				if(image.getBounds(stageVar).intersects(eBullets[i].getBounds(stageVar))) {
					DecreaseHealth();
					stageVar.removeChild(eBullets[i]);
					eBullets.splice(i, 1);
					break;
				}
			}
		}
		
		//Fire the Bullets
		public function BulletFire():void {
				bullet = new Bullet();
				bullet.x = image.x + image.width/2;
				bullet.y = image.y - bullet.height/2;
				stageVar.addChild(bullet);
				bulletArr.push(bullet);
		}

		//Remove Bullets
		public function RemoveBullets():void {
			for(var i:int = bulletArr.length - 1; i >= 0; i--) {
				stageVar.removeChild(bulletArr[i]);
				bulletArr.splice(i, 1);
			}
		}
		
		
		//Decrease Health
		private function DecreaseHealth():void {
			if(Constants.isWhite) { currHP -= 2; }
			else if(Constants.isGreen) { currHP -= 5; }
			else if(Constants.isBlue) { currHP -= 15; }
			else if(Constants.isRed) { currHP -= 20; }
		}

	}//End of Class
}//End of Package