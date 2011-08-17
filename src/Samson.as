package {
    import com.wispagency.display.Loader;
    
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.utils.describeType;
    
    import org.osflash.futures.IFuture;
    import org.osflash.futures.creation.instantSuccess;
    import org.osflash.futures.creation.waitOnCritical;
    import org.osflash.futures.support.isolate;
    import org.osflash.samson.load;
    import org.osflash.samson.loadSingle;

    public class Samson extends Sprite 
	{
        public function Samson() 
		{
			producer()			
        }
		
		protected function producer():IFuture
		{
			return isolate(
				loadSingle('http://taaltreffers.ijstest.nl/language-nll.xml')
					.orElseCompleteWith("<empty></empty>")
					.andThen(onXMLComplete)
			)
				
			function onXMLComplete(xmlRaw:String):IFuture
			{
				trace(xmlRaw)
				
				return loadSingle('http://taaltreffers.ijstest.nl/data/games/minigames/bingo/main.swf')
					.mapComplete(onSWFComplete)
					
				function onSWFComplete(swf:DisplayObject):Array 
				{
					trace(swf.name)
					return [swf, new XML(xmlRaw)]
				}
			}
		}
    }
}

