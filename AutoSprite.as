package  {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.text.TextField;

	public class AutoSprite extends MovieClip {
		public var image:MovieClip;
		public var currHP:int;
		public var maxHP:int;
		
		//Constructor
		public function AutoSprite(){ 			
			maxHP = 100;
			currHP = maxHP;
			trace("Current HP: " + currHP + " Max HP: " + maxHP);
		}
		
		

	}//End of Class
}//End of Package
