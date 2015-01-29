package  {
	
	public class Constants {

		//Variables
		public static var Pause:Boolean;
		
			//Bullet Variables
		public static var isGreen:Boolean;
		public static var isBlue:Boolean;
		public static var isRed:Boolean;
		public static var isWhite:Boolean;
		
			//Phase Variables
		public static var displayNextPhase:Boolean;
		public static var gameOver:Boolean = false;
		public static var gameWon:Boolean = false;
		
		//Constructor
		public function Constants() {
			// constructor code
		}
	
		//Random Numbers within a range.
		public static function randomRange(minNum:Number, maxNum:Number):Number	{  
    		return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);  
		}
	}//End of Class	
}//End of Package
