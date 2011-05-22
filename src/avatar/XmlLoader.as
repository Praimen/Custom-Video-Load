package avatar
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	public class XmlLoader extends Sprite
	{
		
		private var _xmlResult:XML;
		private var myLoader:URLLoader = new URLLoader();
		private var videoBase:VideoTest;
		
		public function XmlLoader(xmlfile:String,videoElement:VideoTest){
			myLoader.addEventListener(Event.COMPLETE, processXML);
			myLoader.load(new URLRequest(xmlfile));	
			this.videoBase = videoElement;			
		}
	
		
		/*====================== Process XML ==============================	
		processXML is called by the myLoader URL Request and
		will populate the myXML object 
		check to see if the object is null
		and then call the playVideo() to start
		to start building the video	*/
		
		private function processXML(e:Event):void {
			var myXML:XML = new XML(e.target.data);
			try{
				if(myXML != null){						
					videoBase.setXML(myXML);
				}
			}catch(e:Error){
				trace("XML load Failed");
			}
			
		}
		
		//*********************************************************************
		
		
		
		
	}
}