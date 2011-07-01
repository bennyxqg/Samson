package {
    import flash.display.Sprite;
    import flash.events.ErrorEvent;
    import flash.net.URLRequest;
    
    import org.osflash.samson.load;
    import org.osflash.samson.loadSingle;
    import org.osflash.samson.transformers.stringToXMLList;

    public class Samson extends Sprite {

        public function Samson() {
			
			loadSingle(new URLRequest('test.xml'))
				.onCompleted(function (raw:String):void {
					trace('onCompleted:', raw)
				})
				.onCancelled(function (e:ErrorEvent):void {
					trace('onCancelled:', e)
				})
			
//			load('moo.xml')
//				.orElseCompleteWith(<loggingConfig>Moo</loggingConfig>)
//				.onCompleted(function (rawLoggingXML:String):void {
//					trace('rawLoggingXML:', rawLoggingXML)	
//				})
        }
    }
}

