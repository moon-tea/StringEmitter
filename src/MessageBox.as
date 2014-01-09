 package  {

    import flash.display.Sprite;
    import flash.text.TextField;
 
    public class MessageBox extends Sprite 
	{
		public var outPutString:String;
		public var Width:Number;
		public var textfield:TextField;
		
		function MessageBox(outPutString:String = "Hello World!", Width:Number = 300 )
		{
         	this.outPutString = outPutString;
			this.Width = Width;
			init();
        }
		
		private function init():void 
		{
			var msgbox:Sprite = new Sprite();

          // drawing a white rectangle
          msgbox.graphics.beginFill(0xFFFFFF); // white
          msgbox.graphics.drawRect(0 ,0, Width, 20); // x, y, width, height
          msgbox.graphics.endFill();
 
          // drawing a black border
          msgbox.graphics.lineStyle(2, 0x000000, 100);  // line thickness, line color (black), line alpha or opacity
          msgbox.graphics.drawRect(0, 0, Width, 20); // x, y, width, height
        
          textfield = new TextField();
          textfield.text = outPutString;

          addChild(msgbox);   
          addChild(textfield);
		}
		public function changeText():void 
		{
			textfield.text = outPutString;
		}
	}		
}
