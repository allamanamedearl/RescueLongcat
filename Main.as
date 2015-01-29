package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import flash.display.StageQuality;
	
	//SOUND IMPORTS
	import flash.media.Sound;
	import flash.net.*;

	//TWEENING IMPORTS
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.text.TextField;
	import flash.media.SoundChannel;
	import flash.text.TextFormat;
	
	public class Main extends MovieClip {
		//Menus
		public var menu:MovieClip;
		public var options:MovieClip;
		private var bg:MovieClip;
		private var bg2:MovieClip;
		
		//Game Assets
		public var gui:GUI;
		public var player:PlayerSprite;
		private var winScreen:MovieClip;
		private var loseScreen:MovieClip;
		
		//Sounds
		public var menuSong:Sound = new Sound(); 
		public var soundChannel:SoundChannel = new SoundChannel();

		//Variables
		public var isMute:Boolean;
		private var blank:MovieClip;
		
		//Time Variables
		private var dt:Number = 1.0/stage.frameRate;
		
		//Variables for Options Menu
		public var mute_circle_yes:Point;
		public var mute_circle_no:Point;
		public var mute:MovieClip;


		//Phases
		private var Phase01:PhaseOne;
		private var Phase02:PhaseTwo;
		private var Phase03:PhaseThree; 
		public static var GameState:int;
		
		//Next Phase Variables
		private var npText:TextField;
		private var npText2:TextField;

		//Constructor
		public function Main():void {
			menu = new MenuScreen();
			menu.x = 0;
			menu.y = 0; 
			this.addChild(menu);
			
			//Background
			bg = new Background();
			bg2 = new Background();
			stage.addChildAt(bg, 0);
			stage.addChildAt(bg2, 0);
			
			//Sounds
			menuSong.load(new URLRequest("Audio/m_song.mp3"));
			soundChannel = menuSong.play(0, 100, null);
			
			//Initialize the Menu
			menu.addEventListener("CLICKED_START", startGame, false, 0, true);
			menu.addEventListener("CLICKED_OPTIONS", optionMenu, false, 0, true);
			menu.addEventListener("CLICKED_EXIT", exitPage, false, 0, true);
			
			//Initialize Variables
			isMute = false;
			loseScreen = new lose_screen();
			winScreen = new win_screen();
		}
		
		/***************************************************
		*					MENU
		***************************************************/
		
		//Brings up the Option Menu
		public function optionMenu(e:Event):void {
			this.removeChild(menu);
			options = new OptionsMenu();
			options.x = 50;
			options.y = 100;
			this.addChild(options);
			
			
			options.addEventListener("LOW_QUALITY", low_qual);
			options.addEventListener("MEDIUM_QUALITY", med_qual);
			options.addEventListener("HIGH_QUALITY", high_qual);
			
			function low_qual(e:Event):void { stage.quality = StageQuality.LOW; }
			function med_qual(e:Event):void { stage.quality = StageQuality.MEDIUM; }
			function high_qual(e:Event):void { stage.quality = StageQuality.HIGH; }
			
			
			//Checks if the Back Key on the Emulator has been pressed
			options.addEventListener("BACK_KEY", backKeyFun);
			//Will Remove the Options, and replaced with Menu.
			function backKeyFun(e:Event):void {
				removeChild(options);
				addChild(menu);
				e.target.removeEventListener("BACK_KEY", backKeyFun);
			}
		}
		
		//Brings you to the Exit Page
		public function exitPage(e:Event):void {
			trace("Please Exit the Swf!");
			//stage.nativeWindow.close();
		}
		
		/***************************************************
		*					THE GAME
		***************************************************/
		
		//Starts the Game
		public function startGame(e:Event):void {
			//Removes unnecessary things for in Game. 
			this.removeChild(menu);
			e.target.removeEventListener("CLICKED_START", startGame);
			e.target.removeEventListener("CLICKED_OPTIONS", optionMenu);
			e.target.removeEventListener("CLICKED_EXIT", exitPage);
			
			//Initialize the Game
			init();
		}
		
		//Initialize the Game Variables
		public function init():void {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			//Add the Game Screen
			gui = new GUI(stage);
			
			//Init Variables
			GameState = 1;
			blank = new Blank_Txture();
			
			this.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		
		
		/***************************************************
		*				UPDATE METHODS
		***************************************************/
		
		//Update
		public function Update(e:Event)
		{			
			if(!Constants.Pause) {
				UpdateBackground();
				gui.Update();
				switch(GameState) {
					case 1: //Phase One
						if(Phase01 == null) { Phase01 = new PhaseOne(stage); gui.greenActive = true; }
						if(!Constants.displayNextPhase) { Phase01.Update(); }
						else { DisplayPhase(); }
						break;
					case 2: //Phase Two
						if(Phase02 == null) { Phase02 = new PhaseTwo(stage); Phase01 = null; gui.blueActive = true;  }
						if(!Constants.displayNextPhase) { Phase02.Update(); }
						else { DisplayPhase(); }
						break;
					case 3: //Phase Three
						if(Phase03 == null) { Phase03 = new PhaseThree(stage); Phase02 = null; gui.redActive = true;}
						if(!Constants.displayNextPhase) { Phase03.Update(); }
						else { DisplayPhase(); }
						break;
						
				}				
			}//End of Pause
			
			if(Constants.gameOver) {
				if(!stage.contains(loseScreen)) { stage.addChild(loseScreen); }
				if(!loseScreen.hasEventListener(TouchEvent.TOUCH_TAP)) { loseScreen.addEventListener(TouchEvent.TOUCH_TAP, ReturnToMenu); }
			}
			if(Constants.gameWon) {
				if(!stage.contains(winScreen)) { stage.addChild(winScreen); }
				if(!winScreen.hasEventListener(TouchEvent.TOUCH_TAP)) { winScreen.addEventListener(TouchEvent.TOUCH_TAP, ReturnToMenu); }
			}
		}
		
		//Update the Background
		private function UpdateBackground():void {
			if(!Constants.displayNextPhase) {
				bg.y += 2;
				if(bg.y > stage.stageHeight) {
					bg.y = bg2.y - bg2.height;
				}
				else if (bg.y < 0) {
					bg2.y = bg.y + bg.height;
				}
				else {
					bg2.y = bg.y - bg.height;
				}
			}
		}
		
		/***************************************************
		*				SERVICE METHODS
		***************************************************/
				
		//Display NextPhase Screen
		private function DisplayPhase():void {
			if(!stage.contains(blank)) {
				//Add Blank Texture
				blank.addEventListener("BLANK_TAP", NextPhase);
				stage.addChild(blank);
							
				//Add the Text
				var tf:TextFormat = new TextFormat();
				tf.color = 0xFFFFFF;
				tf.font = "Calibri";
				tf.size = 20;
									
				npText = new TextField();
				npText.width = 200;
				npText.x = stage.stageWidth / 2 - npText.width / 2 + 20;
				npText.y = stage.stageHeight / 2 - npText.height;
				npText.mouseEnabled = false;
				npText.text = "COMPLETED PHASE";
				npText.setTextFormat(tf);
				
									
				npText2 = new TextField();
				npText2.width = 250;
				npText2.x = stage.stageWidth / 2 - npText2.width / 2 + 10;
				npText2.y = stage.stageHeight / 2;
				npText2.mouseEnabled = false;
				npText2.text = "Tap anywhere to continue...";
				npText2.setTextFormat(tf);
				
				stage.addChild(npText);
				stage.addChild(npText2);
			}
		}
		
		//Go to Next Phase
		public function NextPhase(e:Event):void {
			Constants.displayNextPhase = false;
			
			//Remove The Display Screen
			stage.removeChild(blank);
			stage.removeChild(npText);
			stage.removeChild(npText2);
			
			//Increment the GameState
			GameState++;
			if(GameState > 3) { 
				Constants.gameWon = true;
				Constants.Pause = true;
			}
		}
		
		//Return to Main Menu
		private function ReturnToMenu(e:TouchEvent):void {
			
			stage.removeEventListener(Event.ENTER_FRAME, Update);

			if(loseScreen.hasEventListener(TouchEvent.TOUCH_TAP)) { loseScreen.removeEventListener(TouchEvent.TOUCH_TAP, ReturnToMenu); }
			if(winScreen.hasEventListener(TouchEvent.TOUCH_TAP)) { winScreen.removeEventListener(TouchEvent.TOUCH_TAP, ReturnToMenu); }
			
			if(stage.contains(loseScreen)) { stage.removeChild(loseScreen); }
			if(stage.contains(winScreen)) { stage.removeChild(winScreen); }
			
			//Remove Level
			if(Phase01 != null) { Phase01.RemoveAll(); Phase01 = null; }
			if(Phase02 != null) { Phase02.RemoveAll(); Phase02 = null; }
			if(Phase03 != null) { Phase03.RemoveAll(); Phase03 = null; }
			
			//Remove GUI
			gui.RemoveAll();
			gui = null;
			
			//Initialize Main Menu
			this.addChild(menu);
			menu.addEventListener("CLICKED_START", startGame, false, 0, true);
			menu.addEventListener("CLICKED_OPTIONS", optionMenu, false, 0, true);
			menu.addEventListener("CLICKED_EXIT", exitPage, false, 0, true);
			
			Constants.gameOver = false;
			Constants.gameWon = false;
		}

	}//End of Class
}//End of Package
