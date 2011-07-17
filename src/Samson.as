package {
    import flash.display.Sprite;
    import flash.events.ErrorEvent;
    
    import org.osflash.futures.IFuture;
    import org.osflash.futures.creation.instantSuccess;
    import org.osflash.futures.support.isolate;
    import org.osflash.samson.load;

    public class Samson extends Sprite {

        public function Samson() {
			
//			loadSingle(new URLRequest('test.xml'))
			
			producer()
				.onComplete(function (raw:String):void {
					trace('client onCompleted:', raw)
				})
				.onCancel(function (e:ErrorEvent):void {
					trace('client onCancelled:', e)
				})
			
//			load('moo.xml')
//				.orElseCompleteWith(<loggingConfig>Moo</loggingConfig>)
//				.onCompleted(function (rawLoggingXML:String):void {
//					trace('rawLoggingXML:', rawLoggingXML)	
//				})
        }
		
		protected function producer():IFuture
		{
			return isolate(
				load('producer', 'testd.xml')
					.orElseCompleteWith("<empty></empty>")
					.andThen(function (kickstartXMLRaw:String):IFuture {
						return instantSuccess('kickstartRaw', new XML(kickstartXMLRaw))
//						return configureModel(flashVars, config)
//							.mapComplete(function (configXMLExpanded:XMLList):Array {
//								const config:Config = new Config(flashVars, configXMLExpanded)
//								const language:ILanguage = buildLanguage(flashVars.locale, configXMLExpanded)
//								return [config, language, new XML(kickstartXMLRaw)]
//							})
					})
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

