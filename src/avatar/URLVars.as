package avatar
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	public class URLVars extends Sprite	{
		
		private var _flashVars:Object;
		private var _myXML:XML
		private var xmlLoad:XmlLoader;
		private var myLoader:URLLoader = new URLLoader();			
		
		private var videoBase:VideoTest;
		
		public function URLVars(videoElement:VideoTest){
			_flashVars = new Object();			
			loaderInfo.addEventListener(Event.COMPLETE, loaderComplete);	
			this.videoBase = videoElement;
		}
		
		
		private function loaderComplete(evt:Event):void{
			
			_flashVars = LoaderInfo(this.root.loaderInfo).parameters;			
			//videoBase.getFlashVars(_flashVars);			
			
		}
		
		
		
		
		
		
	}// end Class
}//end Package