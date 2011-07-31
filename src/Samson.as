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
			
//			const loader:Loader = new Loader()
//			loader.addEventListener(Event.COMPLETE, function (e:Event):void {
//				const minigame:DisplayObject = loader.content
//			})
//			loader.load(new URLRequest('http://taaltreffers.ijstest.nl/data/games/minigames/bingo/main.swf'))
			
			loadSingle('ttSwftest', 'http://taaltreffers.ijstest.nl/data/games/minigames/bingo/main.swf')
				.onComplete(function (swf:DisplayObject):void {
					const typeInfo:XML = describeType(swf) 
					trace('Yuss')
				})
//			loadSingle(new URLRequest('test.xml'))
			
//			producer()
//				.onComplete(function (raw:String):void {
//					trace('client onCompleted:', raw)
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
		
//		protected function producer():IFuture
//		{
//			return isolate(
//			return load('producer', 'test.xml')
//					.orElseCompleteWith("<empty></empty>")
//					.andThen(function (kickstartXMLRaw:String):IFuture {
//						return instantSuccess('kickstartRaw', new XML(kickstartXMLRaw))
//						return configureModel(flashVars, config)
//							.mapComplete(function (configXMLExpanded:XMLList):Array {
//								const config:Config = new Config(flashVars, configXMLExpanded)
//								const language:ILanguage = buildLanguage(flashVars.locale, configXMLExpanded)
//								return [config, language, new XML(kickstartXMLRaw)]
//							})
//					})
//			)
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
//		}
    }
}

