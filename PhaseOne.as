package  {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TouchEvent;

	public class PhaseOne extends MovieClip {
		//Variables
		private var bossType:int;
		private var isBossFight:Boolean;
		
		//Spawning Variables
			//Minions
		protected var MINION_SPAWN:Number;
		protected var minion_st:Number;
		
			//Boss
		protected var BOSS_SPAWN:Number;
		protected var boss_st:Number;
		
			//Bullets
		protected var BULLET_SPAWN:Number = 0.15;
		protected var bullet_st:Number;
		
		//Time Variables
		protected var dt:Number = 1.0/24;
		
		//Sprites
		public var player:PlayerSprite;
		public var enemyArr:Array;
		
		//Assets
		private var StageVar:Stage;
		private var blank:MovieClip;
	
		//Constructor
		public function PhaseOne(_stage:Stage){
			//Initialize Spawn Times
			MINION_SPAWN = 3;
			minion_st = 0;
			BOSS_SPAWN = 30.9;
			boss_st = 0;
			bullet_st = 0;
		
			//Initialize Boss
			bossType = 1;
			isBossFight = false;
			
			//Set Reference for Stage
			StageVar = _stage;
			
			//Initialize the Sprites
			player = new PlayerSprite(StageVar);
			enemyArr = new Array();
			
			//Add the Input Listeners
			player.image.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin); 
			player.image.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}
		
		
		//Update
		public function Update():void {
			minion_st += 1 * dt;
			boss_st += 1 * dt;
			bullet_st += 1 * dt;
			
			//Update the Sprites
			player.Update();
			
			//Spawn Enemies
			SpawnEnemy();
			
			//Update Enemies in Array
			for(var i:int = 0; i < enemyArr.length; i++) {
				enemyArr[i].Update();
				//Check Bullet Collision
				player.CheckBulletCollision(enemyArr[i].bulletArr, enemyArr[i].eType);
				enemyArr[i].CheckBulletCollision(player.bulletArr);
				
				if(enemyArr[i].y >= 650) {
					StageVar.removeChild(enemyArr[i].image);
					enemyArr[i].RemoveBullets();
				}
			}
			
			//Fire Bullets
			if(bullet_st >= BULLET_SPAWN) {
				//Fire the Bullets
				player.BulletFire();	
				for(i = 0; i < enemyArr.length; i++) {
					enemyArr[i].BulletFire();
				}
				bullet_st = 0;
			}
			
			//Check if Enemies HP is Below 0
			for(i = 0; i < enemyArr.length; i++) {
				if(enemyArr[i].currHP <= 0) {
					if(isBossFight) {
						if(enemyArr[i].eType == "BOSS_01") {
							RemoveAll();
							Constants.displayNextPhase = true;
							break;
						}
					}
					trace("Enemy is dead!");
					StageVar.removeChild(enemyArr[i].image);
					enemyArr[i].RemoveBullets();
					enemyArr.splice(i, 1);
				}
			}
			DisplayScreen();
		}
		
		/***************************************************
		*				SERVICE METHODS
		***************************************************/
		private function SpawnEnemy():void {
			if(!isBossFight) {
				//Check Minion Spawn Time
				if(minion_st >= MINION_SPAWN) {
					var enemy:EnemySprite = new EnemySprite(StageVar, 0);
					StageVar.addChild(enemy.image);
					enemyArr.push(enemy);
					minion_st = 0;
				}
			
				//Check Boss Spawn Time
				if(boss_st >= BOSS_SPAWN) {
					var enemy:EnemySprite = new EnemySprite(StageVar, bossType); //1 - Phase one boss
					StageVar.addChild(enemy.image);
					enemyArr.push(enemy); 
					boss_st = 0;
					isBossFight = true;
				}
			}
		}
		
		
		//Display Lose Screen
		public function DisplayScreen():void {	
			//If Player is Dead
			if(player.currPlayerHP <= 0) {				
				Constants.Pause = true;
				player.image.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				player.image.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
				player.image.gotoAndStop(1);
				Constants.gameOver = true;
			}
		}
		
		//Remove Everything from Stage
		public function RemoveAll():void {
			if(StageVar.contains(player.image)) { StageVar.removeChild(player.image); }
			player.RemoveAll();
			for(var i:int = enemyArr.length - 1; i >= 0; i--) {
				if(StageVar.contains(enemyArr[i].image)) {
					enemyArr[i].RemoveBullets();
					StageVar.removeChild(enemyArr[i].image);
					enemyArr.splice(i, 1);
				}
			}
		}
		
		/***************************************************
		*				INPUT METHODS
		***************************************************/
 
 		//Move the Player w/ Touch
		private function onTouchBegin(e:TouchEvent) { 
   			e.target.startTouchDrag(e.touchPointID); 
		} 
 
		//Stop Moving the Player w/ Touch
		private function onTouchEnd(e:TouchEvent) { 
    		e.target.stopTouchDrag(e.touchPointID); 
		}

	}//End of Class
}//End of Namespace
