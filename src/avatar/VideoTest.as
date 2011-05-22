package avatar
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.text.*;
	
	

	[SWF(backgroundColor="#666666", frameRate="100", width="350", height="450")]
	public class VideoTest extends Sprite
	{
		private var vid:Video = new Video(800, 450);
		private var nc:NetConnection = new NetConnection();
		private var ns:NetStream;
		private var listener:Object = new Object();		
		private var currentBytesLoaded:Array = new Array();;
		private var totalBytes:uint;
		private var bufferLoaded:uint;
		private var currentVideoStatus:String;
		private var vidPlaying:Boolean;
		private var vidInit:Boolean;
		private var statusMessage:String = "Loading Assistant";
		
		private var xmlFile:String;		
		private var path:String;
		private var pageName:String;
		
		private var statusTxt:TextField = new TextField();
		private var videoContainer:Sprite = new Sprite();
		private var flashVars:Object = new Object();
		private var videoXML:XML = new XML();
		
		private var urlVar:URLVars
		private var myTween:TweenLite; 
		//private var videoContainer:
		
		public function VideoTest()	{				
			
			loaderInfo.addEventListener(Event.COMPLETE, loaderComplete); //uncomment for live run
			
			//initText();//uncomment for local testing
		}
		
		private function loaderComplete(evt:Event):void{
			//load Flash Variables from page
			flashVars = LoaderInfo(this.root.loaderInfo).parameters;	
			path = flashVars["skinPath"];
			xmlFile = flashVars["xmlFile"];
			pageName = flashVars["pageName"];
			getXML();
		}					
	
		
		public function getXML():void{
			//attempts to load the XML
			if(path != null){
				try{					
					var xmlLoad:XmlLoader = new XmlLoader(path + xmlFile, this);
					
				}catch(e:Error){ trace("error occurred while requesting the XML file"); }
			}					
		}
		
		public function setXML(xml:XML):void{
			
			//********* 
			//this most like needs to be put into a class that dispatches an event that will 
			//then trigger a get function from the class, then set the loaded XML 
			//and finally perform the needed validation check on the XML node requests
			//**********
			//set the XML
			videoXML = xml;
			
				if(videoXML != null){
					//attempts validate the node request, if it is not valid the Video will be Stopped
					//trace("THIS IS THE VIDEO XML RESULT: "+videoXML.VIDEO.(@TITLE==pageName));
					if(videoXML.VIDEO.(@TITLE==pageName) == "" || videoXML.VIDEO.(@TITLE==pageName) == null || videoXML.VIDEO.(@TITLE==pageName) == undefined  ){
						stopVideo();						
					}else{
						initText();
					}
				}else{ trace("error: improperly formatted node request or node not found in XML tree");	}			
		}
		
		
		
		private function initText():void{
			//initiallizes the status Report Text and embeds the font
			var embFonts:EmbedFonts = new EmbedFonts(20);
			var newTextFormat:TextFormat = embFonts.format;
			
			statusTxt.antiAliasType = AntiAliasType.ADVANCED;
			statusTxt.defaultTextFormat = newTextFormat;
			//statusTxt.background = true;
			//statusTxt.backgroundColor = 0x000000;
			//statusTxt.multiline = true;
			statusTxt.autoSize = TextFieldAutoSize.CENTER;
			statusMessage = "Loading Assistant";
			statusTxt.textColor = 0xFFFFFF;
			statusTxt.embedFonts = true;
			statusTxt.text = statusMessage; 
			statusTxt.x = stage.stageWidth;
			statusTxt.y = stage.stageHeight - statusTxt.height;
			statusTxt.width = stage.stageWidth;
			statusTxt.height = 50;
			
			initTextAnim();
		}
		
				
		private function initTextAnim():void{	
			TweenPlugin.activate([AutoAlphaPlugin]);//avtivates the Auto Alpha of Tweenlite	
			myTween = new TweenLite(statusTxt, 1, {x:150, ease:Back.easeOut});//inital status text animation
			playVideo();
		}
		
		
		private function netStatusHandler(event:NetStatusEvent):void {
			
			currentVideoStatus = event.info.code;
			trace(currentVideoStatus);
				switch (currentVideoStatus) {					
					
					case "NetStream.Play.Start":
						//starts the video as the first inital play through and pauses the video for buffering
						//trace("starting");
						vidInit = true;
						ns.pause();
						vidPlaying = false;
						addEventListener(Event.ENTER_FRAME, onEnterFrame);
					break;
					
					case "NetStream.Buffer.Empty":
						//when Empty is triggered a array value is stored at that byte count
						currentBytesLoaded[0] = ns.bytesLoaded;
						totalBytes = ns.bytesTotal		
						//update Status Text to user, show status since buffer is empty
										
						//Flash has no "NetStream.Play.Complete" for progressive downloads only streaming
						//when buffer is empty this even fire if the it will check to see if the entire video has loaded
						
							if(currentBytesLoaded[0] == totalBytes){	
								removeEventListener(Event.ENTER_FRAME, onEnterFrame);
								stopVideo();
							}else{
								//if it is not the end of the video then pause for buffering
								trace("current Bytes loaded: "+currentBytesLoaded[0]);
								statusMessage = "Buffering Video";
								ns.pause();
								vidPlaying = false;								
								videoContainer.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));	
							}
					break;			
						
					
				}//end Switch
			
			
		}
		
		
		private function mouseStopVideo(evt:MouseEvent):void{
			stopVideo();
		}		
		
		private function stopVideo():void{
			//used when the video is no longer needed and will fade out
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			videoContainer.removeEventListener(MouseEvent.ROLL_OVER, showControl);
			videoContainer.removeEventListener(MouseEvent.ROLL_OUT, hideControl);
			ns.close();			
			var alphaTween:TweenLite = new TweenLite(videoContainer, 1, {autoAlpha:0,ease:Circ.easeOut});
			
		}
		
		private function hideControl(evt:MouseEvent):void{	
			statusTxt.text = statusMessage;
			myTween.reverse();
		}
		
		private function showControl(evt:MouseEvent):void{
			if(vidPlaying){
				//if vidPlaying is true then video is not buffering and this message is used
				statusMessage = "Click to Close Video";	
			}
			statusTxt.text = statusMessage;
			myTween.play();
		}	
		
		
		private function playVideo():void{
			
			///something in sequencing is not allowling videoContainer to be placed out side function
			addChild(videoContainer);
			
			videoContainer.mouseEnabled = true;
			videoContainer.mouseChildren = false;
			videoContainer.buttonMode = true;
			videoContainer.addEventListener(MouseEvent.ROLL_OVER, showControl);
			videoContainer.addEventListener(MouseEvent.ROLL_OUT, hideControl);
			videoContainer.addEventListener(MouseEvent.CLICK, mouseStopVideo);
			
			vid.smoothing = true;
			videoContainer.addChild(vid);			
			videoContainer.addChild(statusTxt);
			vid.x = stage.stageWidth - (vid.width/1.5);//custom positioning of video 				
			
			nc.connect(null);			
			ns = new NetStream(nc);	
			vid.attachNetStream(ns);
			
			listener.onPlayStatus = function(evt:Object):void {};//prevents some suplerfulous error messages			
			ns.client = listener;			
						
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ns.play(path+videoXML.VIDEO.(@TITLE==pageName))//uncomment for live run
			//ns.play("http://www.drvollenweider.com/Portals/_default/Skins/siteSkin/videos/Cue_1.flv");//uncomment for local testing
		}
		
		
		
		private function onEnterFrame(e:Event):void{
			var videoLoadedPercent:uint = (ns.bytesLoaded/ns.bytesTotal) * 100;
			var pecentStartPlaying:uint = 15;//when should the video start playing
			var bufferValue:uint = ns.bytesTotal/5;//divides the video into sections to derive the desired buffervalue
			var bufferMark:uint = currentBytesLoaded[0] + bufferValue;//the current bytes loaded to the desired buffer value
			var bufferLoaded:uint = (ns.bytesLoaded/bufferMark ) * 100; //used to see a percentage value of the buffer load
			//if the percentage of video bytes loaded is pass the start bytes value and the video is paused on it's inital run
			//then the video will start to play
			if (videoLoadedPercent > pecentStartPlaying && !vidPlaying  && vidInit){
				trace("resumed");
				//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				vidPlaying = true;
				vidInit = false;
				ns.resume();
				videoContainer.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));	
			}
			
			
			//currentBytesLoaded array value is populated when the NetStream.Buffer.Empty event is triggered
			//then the Buffer value is added to the currentBytesLoaded array value to mark where the video 
			//should resume play
			if(currentBytesLoaded[0] > 0){
				//if bufferLoaded is over 99% and the video is currently not playing(buffering) the it will play
				//or if the video had compeltely loded
				if (bufferLoaded > 99  && !vidPlaying || videoLoadedPercent == 100){
					currentBytesLoaded[0] = 0;					
					vidPlaying = true;
					ns.resume();
					videoContainer.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));	
					statusMessage = "Buffering Complete";
					
				}			
			}
			
		}
		
		
		
		
	}//end Class
}//end Package