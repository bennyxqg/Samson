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
    import org.osflash.futures.support.isolate;
    import org.osflash.samson.load;
    import org.osflash.samson.loadSingle;

    public class Samson extends Sprite {

        public function Samson() {
			
			loadSingle('image', 'http://taaltreffers.ijstest.nl/data/images/level/6/theme/6/code.jpg')
				.onComplete(function (data:*):void {
					trace('success', data)
				})
				.onCancel(function (e:*):void {
					trace('error', e)
				})
			
//			const loader:Loader = new Loader()
//			loader.addEventListener(Event.COMPLETE, function (e:Event):void {
//				const minigame:DisplayObject = loader.content
//			})
//			loader.load(new URLRequest('http://taaltreffers.ijstest.nl/data/games/minigames/bingo/main.swf'))
			
//			isolate(loadSingle('ttSwftest', 'http://taaltreffers.ijstest.nl/language-nl.xml'))
//				.onComplete(function (xmlRaw:String):void {
//					trace('Yuss we haves XML')
//				})
//			
//			isolate(
//				loadSingle('ttSwftest', 'http://taaltreffers.ijstest.nl/data/games/minigames/bingo/main.swf')
//					.onComplete(function (swf:DisplayObject):void {
//						const typeInfo:XML = describeType(swf) 
//						trace('Yuss we haves swfs')
//					})
//			)
			
//			loadSingle(new URLRequest('test.xml'))
			
//			producer()
//				.onComplete(function (swf:DisplayObject, xml:XML):void {
//					trace('client onCompleted:', swf, xml)
//				})
//				.onCancel(function (e:ErrorEvent):void {
//					trace('client onCancelled:', e)
//				})
			
//			load('moo.xml')
//				.orElseCompleteWith(<loggingConfig>Moo</loggingConfig>)
//				.onCompleted(function (rawLoggingXML:String):void {
//					trace('rawLoggingXML:', rawLoggingXML)	
//				})
        }
		
		protected function producer():IFuture
		{
			return isolate(
				loadSingle('producer', 'http://taaltreffers.ijstest.nl/language-nl.xml')
					.orElseCompleteWith("<empty></empty>")
					.andThen(function (xmlRaw:String):IFuture {
//						return instantSuccess('kickstartRaw', new XML(kickstartXMLRaw))
						return loadSingle('ttSwftest', 'http://taaltreffers.ijstest.nl/data/games/minigames/bingo/main.swf')
							.mapComplete(function (swf:DisplayObject):Array {
								return [swf, new XML(xmlRaw)]
							})
					})
//			)
			)
//			return isolate(
//				load('test.xml', 'testd.xml')
//					.onComplete(fp.producer(function (raw:String):void {
//						trace('producer onCompleted:', raw)
//					}))
//					.onCancel(fp.producer(function (moo:String, e:ErrorEvent):void {
//						trace('producer onCancelled:', e)
//					}))
//			)
//			return isolate(
//				loadSingle(postR('testd.xml', {moo: 'A', boo: 'B'}))
//					.orThen(function ():IFuture {
//						return load('test.xml')
//					})
//					.onComplete(function (raw:String):void {
//						trace('producer onCompleted:', raw)
//					})
//					.onCancel(function (e:ErrorEvent):void {
//						trace('producer onCancelled:', e)
//					})
//			)
		}
    }
}

