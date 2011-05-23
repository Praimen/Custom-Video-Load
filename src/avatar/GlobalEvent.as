package custom
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{	
		// event constants		
		public static const FONT_LOADED:String = "fontLoaded";	
		public static const TEXT_READY:String = "textReady";		
		//public var params:Object;
	
		public function GlobalEvent(type:String, /*params:Object,*/ bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			//this.params = params;
		}
		
		///required override
		public override function clone():Event{
			return new GlobalEvent(type, /*params,*/ bubbles, cancelable);
		}
		
		public override function toString():String{
			return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable");		
		}

		
	}
}
