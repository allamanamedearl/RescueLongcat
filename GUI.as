package  {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class GUI extends MovieClip {

		//Fields and Properties		
			//Unlocked Bullets
		public var greenActive:Boolean;
		public var blueActive:Boolean;
		public var redActive:Boolean;
		public var whiteActive:Boolean;
		
			//Bullet Variables
		private var isGreen:Boolean;
		private var isBlue:Boolean;
		private var isRed:Boolean;
		private var isWhite:Boolean;
		
			//Pause Screen
		private var pauseText:TextField;
		
			//Visuals
		private var ui:MovieClip;
		private var StageVar:Stage;
		private var blank:MovieClip;

		//Constructor
		public function GUI(_StageVar:Stage) {
			//Set the Stage
			StageVar = _StageVar;
			
			//Lock Bullets + Set the First level
			isGreen = false;
			greenActive = false;
			
			isBlue = false;
			blueActive = false;
			
			isRed = false;
			redActive = false;
			
			isWhite = true;
			whiteActive = true;
			
			SetConstants();
			
			//Place the Visuals
			ui = new GameScreen();
			ui.x = 0;
			//ui.y = 0;
			ui.y = 688;
			StageVar.addChild(ui);
			
			//Pause Screen
			Constants.Pause = false;
			
			//Set the Blank Texture
			blank = new Blank_Txture();
			blank.addEventListener("BLANK_TAP", PauseGame);
			
			//Set TextFormat
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.color = 0xFFFFFF;
			txtFormat.size = 45;
			txtFormat.font = "Calibri";
			
			//Set Pause Text Field
			pauseText = new TextField();
			pauseText.text = "PAUSED";
			pauseText.width = 160;
			pauseText.x = StageVar.stageWidth / 2 - pauseText.width / 2;
			pauseText.y = (StageVar.stageHeight - ui.height) / 2 - pauseText.height / 2;
			pauseText.mouseEnabled = false;
			pauseText.setTextFormat(txtFormat);
		
			
			//GUI Events
			ui.addEventListener("PAUSE_GAME", PauseGame);
			ui.addEventListener("WHITE_SWITCH", whiteSwitch);
			ui.addEventListener("GREEN_SWITCH", greenSwitch);
			ui.addEventListener("BLUE_SWITCH", blueSwitch);
			ui.addEventListener("RED_SWITCH", redSwitch);			
		}
		
		/***************************************************
		*				SERVICE METHODS
		***************************************************/
		
		//UPDATE
		public function Update():void {
			if(greenActive) { ui.green_switch.alpha = 1; } 
			else { ui.green_switch.alpha = 0.2; }
			
			if(blueActive) { ui.blue_switch.alpha = 1; } 
			else { ui.blue_switch.alpha = 0.2; }
			
			if(redActive) { ui.red_switch.alpha = 1; } 
			else { ui.red_switch.alpha = 0.2; }
		}
		

		/***************************************************
		*				GUI METHODS
		***************************************************/

		//PAUSE GAME
		public function PauseGame(e:Event):void {
			//Display the Text
			if(!Constants.Pause) { StageVar.addChild(blank); StageVar.addChild(pauseText); }
			else { StageVar.removeChild(blank); StageVar.removeChild(pauseText);}
			
			Constants.Pause = !Constants.Pause;
		}
		
		//White Switch
		public function whiteSwitch(e:Event):void {
			if(whiteActive) {
				isBlue = false;
				isWhite = true;
				isGreen = false;
				isRed = false;
				SetConstants();
			}
		}
		
		//Green Switch
		public function greenSwitch(e:Event):void {
			if(greenActive) {
				if(isGreen) {
					isGreen = false;
					isWhite = true;
				} else {
					isBlue = false;
					isWhite = false;
					isGreen = true;
					isRed = false;
				}
				SetConstants();
			}
		}
		
		//Blue Switch
		public function blueSwitch(e:Event):void {
			if(blueActive) {
				if(isBlue) {
					isBlue = false;
					isWhite = true;
				} else {
					isBlue = true;
					isWhite = false;
					isGreen = false;
					isRed = false;
				}
				SetConstants();
			}
		}
		
		//Red Switch
		public function redSwitch(e:Event):void {
			if(redActive) {
				if(isRed) {
					isRed = false;
					isWhite = true;
				} else {
					isBlue = false;
					isWhite = false;
					isGreen = false;
					isRed = true;
				}
				SetConstants();
			}
		}
		
		//Set Constants
		private function SetConstants():void {
			Constants.isBlue = isBlue;
			Constants.isGreen = isGreen;
			Constants.isRed = isRed;
			Constants.isWhite = isWhite;
		}
		
		//Remove All
		public function RemoveAll():void {
			//Remove Event Listeners
			ui.removeEventListener("PAUSE_GAME", PauseGame);
			ui.removeEventListener("WHITE_SWITCH", whiteSwitch);
			ui.removeEventListener("GREEN_SWITCH", greenSwitch);
			ui.removeEventListener("BLUE_SWITCH", blueSwitch);
			ui.removeEventListener("RED_SWITCH", redSwitch);		
			
			StageVar.removeChild(ui);
		}
	}//End of Class
}//End of Package
