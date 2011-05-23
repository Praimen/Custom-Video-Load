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
		
		public function URLVars(){
			_flashVars = new Object();			
			loaderInfo.addEventListener(Event.COMPLETE, loaderComplete);	
			
		}
		
		
		private function loaderComplete(evt:Event):void{
			
			_flashVars = LoaderInfo(this.root.loaderInfo).parameters;					
			
		}
		
		public function get flashVars():Object{	
			
			return _flashVars;
		}
		
		
		
		
	}// end Class
}//end Package