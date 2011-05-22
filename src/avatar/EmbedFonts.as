package avatar { 
	//import flash.display.*;
	import flash.text.*;
	
	public class EmbedFonts { 
		[Embed(source='../assets/MyriadPro-Semibold.otf', fontName='myFont',embedAsCFF = 'false')] 
		
		private var MyriadPro:Class; 
		
		private var _textFormat:TextFormat;
		public function EmbedFonts (fontSize:int) { 
			Font.registerFont(MyriadPro);
			_textFormat = new TextFormat(); 			
			_textFormat.align = TextFormatAlign.CENTER;			
			_textFormat.size = fontSize; 
			_textFormat.font = "myFont"; 			
						 
		}
		
		public function get format():TextFormat{
			
			return _textFormat;
		}
		
		
	} //end Class
}//End Package