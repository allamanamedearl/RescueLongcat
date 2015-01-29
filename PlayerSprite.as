package  {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.Sprite;
	
	//TWEENING IMPORTS
	import fl.transitions.Tween;
	import fl.transitions.easing.*;

	public class PlayerSprite extends MovieClip {
		//MovieClip
		public var image:MovieClip;
		
		//BULLET VARIABLES
		public var bullet:MovieClip;
		public var bulletArr:Array;
		
		public var stageVar:Stage;
		private var Critical:Boolean;
		
		//PLAYER HP
		public var playerHP:Sprite;
		public var playerHP_bg:Sprite;
		
		//PLAYER VARIABLES
		public var maxPlayerHP:Number = 100;
		public var currPlayerHP:Number;


		//Constructor
		public function PlayerSprite(_stageVar:Stage) {
			image = new Play();
			bulletArr = new Array();
			stageVar = _stageVar;
			
			currPlayerHP = maxPlayerHP;
			Critical = false;
			
			image.x = (stageVar.stageWidth / 2) - (image.width / 2);
			image.y = (stageVar.stageHeight / 2) + 100;
			stageVar.addChild(image);
			
			//PLAYER HP UNDERLAY
			playerHP_bg = new Sprite();
			playerHP_bg.graphics.beginFill(0x800000);
			playerHP_bg.graphics.drawRect(0, 0, currPlayerHP * 1.5, 2);
			playerHP_bg.graphics.endFill();

			playerHP_bg.x = 10;
			playerHP_bg.y = 700;
			stageVar.addChildAt(playerHP_bg, 2);
			
			//PLAYER HP OVERLAY
			playerHP = new Sprite();
			playerHP.graphics.beginFill(0x18000);
			playerHP.graphics.drawRect(0, 0, currPlayerHP * 1.5, 2);
			playerHP.graphics.endFill();

			playerHP.x = playerHP_bg.x;
			playerHP.y = playerHP_bg.y;
			stageVar.addChildAt(playerHP, 3);
		} 
		
		/***************************************************
		*				UPDATE METHOD
		***************************************************/
		
		//Update
		public function Update():void {
			//Move the Bullets
			for(var i:int = 0; i < bulletArr.length; i++) {
				bulletArr[i].y -= 10;
				
				//Check if Bullets offscreen
				if(bulletArr[i].y < 0) {
					stageVar.removeChild(bulletArr[i]);
					bulletArr.splice(i, 1);
				}
			}
			
			if(currPlayerHP < maxPlayerHP / 4 && !Critical) {
				Critical = true;
				image.gotoAndPlay(2);
			}
		}
		
		/***************************************************
		*				SERVICE METHODS
		***************************************************/
		
		//Check Bullet Collision
		function CheckBulletCollision(eBullets:Array, type:String):void {
			for(var i:int = 0; i < eBullets.length; i++) {
				if(image.getBounds(stageVar).intersects(eBullets[i].getBounds(stageVar))) {
					stageVar.removeChild(eBullets[i]);
					eBullets.splice(i, 1);
					DecreasePlayerHealth(type); //Decrease the HP Bar
					break;
				}
			}
		}
		
		//Fire the Bullets
		public function BulletFire():void {
			if(Constants.isWhite) { bullet = new Bullet(); }
			else if(Constants.isGreen) { bullet = new GreenBullet(); }
			else if(Constants.isBlue) { bullet = new BlueBullet(); }
			else if(Constants.isRed) { bullet = new RedBullet(); }
				bullet.x = image.x + image.width/2;
				bullet.y = image.y - bullet.height/2;
				stageVar.addChild(bullet);
				bulletArr.push(bullet);
		}

		
		//Decrease the Player's Health
		private function DecreasePlayerHealth(type:String):void {
			var prevPlayerHP:Number = currPlayerHP;
			
			if(type == "MINION" || type == "MINION_02") { currPlayerHP -= 1; }
			else if (type == "BOSS_01") { currPlayerHP -= 5; }
			else if (type == "BOSS_02") { currPlayerHP -= 10; }
			else if (type == "BOSS_03") { currPlayerHP -= 15; }
			else if (type == "BOSS_FINAL") { currPlayerHP -= 25; }
			
			
			var Old:Number = prevPlayerHP * 0.01;
			var New:Number = currPlayerHP * 0.01;

			var healthTween:Tween = new Tween(playerHP, "scaleX", None.easeOut, Old, New, 0.5, true);
		}

		
		//Remove All
		public function RemoveAll():void {
			RemoveBullets();
			if(stageVar.contains(playerHP)) { 
				stageVar.removeChild(playerHP);
				stageVar.removeChild(playerHP_bg);
			}
		}

		//Remove Bullets
		public function RemoveBullets():void {
			for(var i:int = bulletArr.length - 1; i >= 0; i--) {
				if(stageVar.contains(bulletArr[i])) { 
				   stageVar.removeChild(bulletArr[i]); 
					bulletArr.splice(i, 1);
				}
			}
		}
	}//End of Class
}//End of Package
