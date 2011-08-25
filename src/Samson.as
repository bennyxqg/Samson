package {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    import org.osflash.futures.IFuture;
    import org.osflash.samson.load;
    import org.osflash.samson.loadSingle;

    public class Samson extends Sprite 
	{
        public function Samson() 
		{
//			loadSingle('http://taaltreffers.ijstest.nl/data/images/level/6/theme/7/diervriendelijk.jpg')
			loadSingle('tests.xml')
				.onComplete(function (data:*):void {
					trace('complete')
				})
//				.onCancel(function (error:Error):void {
//					trace('cancel error:', error.message)
//				})
				
			
//			producer()			
        }
		
		protected function producer():IFuture
		{
			return load('http://taaltreffers.ijstest.nl/language-nl.xml')
				.orElseCompleteWith("<empty></empty>")
				.andThen(onXMLComplete)
				.isolate()
				
			function onXMLComplete(xmlRaw:String):IFuture
			{
				trace(xmlRaw)
				
				return loadSingle('http://taaltreffers.ijstest.nl/data/games/minigames/bingo/main.swf')
					.mapComplete(onSWFComplete)
					.isolate()
					
				function onSWFComplete(swf:DisplayObject):Array 
				{
					trace(swf.name)
					return [swf, new XML(xmlRaw)]
				}
			}
		}
    }
}

