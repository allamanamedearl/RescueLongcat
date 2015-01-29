package  {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TouchEvent;
	
	public class PhaseMain extends MovieClip {
		//Variables
		protected var bossType:int;
		protected var loseScreen:MovieClip;
		protected var winScreen:MovieClip;
		protected var isBossFight:Boolean;
		
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
		//private var blank:MovieClip;
	
		
		//Constructor
		public function PhaseMain(_stage:Stage) {
			//Initialize Enemy Array
			enemyArr = new Array();
			player = new PlayerSprite(_stage);
			
			//Set the StageVar
			StageVar = _stage;
			
			//Add the Input Listeners
			player.image.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin); 
			player.image.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}

		//Update
		public function Update():void {
			minion_st += 1 * dt;
			boss_st += 1 * dt;
			bullet_st += 1 * dt;
			
			//Update Enemies in Array
			for(var i:int = 0; i < enemyArr.length; i++) {
				enemyArr[i].Update();
				//Check Bullet Collision
				player.CheckBulletCollision(enemyArr[i].bulletArr, enemyArr[i].eType);
				enemyArr[i].CheckBulletCollision(player.bulletArr);
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
					trace("Enemy is dead!");
					StageVar.dispatchEvent(new Event("REMOVE_CHILD"));
					enemyArr.splice(i, 1);
				}
			}
		}
		
	}//End of Class	
}//End of Package
