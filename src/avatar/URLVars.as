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
		}		
		
		public function loaderComplete(evt:Event):void{				
			_flashVars = LoaderInfo(evt.target).parameters;					
			GlobalDispatcher.GetInstance().dispatchEvent(new GlobalEvent(GlobalEvent.FLASHVARS_LOADED));
		}
		
		public function get flashVars():Object{			
			return _flashVars;
		}		
		
	}// end Class
}//end Package