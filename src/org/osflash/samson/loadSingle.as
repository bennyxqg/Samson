package org.osflash.samson
{
	import com.wispagency.display.Loader;
	
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.futures.IFuture;
	import org.osflash.futures.creation.Future;
	import org.osflash.samson.request.processRequestVariables;
	
	/**
	 *
	 * <p>valid signitures
	 * <ul>
	 * 		<li>function(urlOrUrlRequest:[String|UrlRequest]):FutureProgressable</li>
	 * 		<li>function(urlOrUrlRequest:[String|UrlRequest], data:Object):FutureProgressable</li>
	 *   	<li>function(urlOrUrlRequest:[String|UrlRequest], data:Object, dataFormat:String[URLLoaderDataFormat]):FutureProgressable</li>
	 * 		<li>function(urlOrUrlRequest:[String|UrlRequest], context:LoaderContext):FutureProgressable</li>
	 * </ul>
	 * </p> 
	 */	
	public function loadSingle(stringOrURLRequest:*, ...rest):IFuture
	{
		const urlRequest:URLRequest = (stringOrURLRequest is URLRequest)
			? stringOrURLRequest
			: new URLRequest(stringOrURLRequest.toString())
		
		const future:Future = new Future()
		const ioError:IOError = new IOError()
		const securityEvent:SecurityError = new SecurityError()
		
		// handle how the loading request can be cancelled
		future.onCancel(function (...args):void {
			removeEvents()
			
			try { loader.close() }
			catch (e:Error) {}
			
			if (isBinary && loader.hasOwnProperty('unloadAndStop'))
			{
				loader.unloadAndStop()
			}
		})
		
		// remove any arguments before type checking
		const urlStripped:String = urlRequest.url.replace(/\?.*$/, '')
		const isAudio:Boolean = urlStripped.search('\.mp3|\.aac') >= 0
		const isBinary:Boolean = urlStripped.search('\.swf$|\.png$|\.jpg$|\.jpeg$') >= 0
		
		var loader:Object
		var eventReporter:IEventDispatcher
		
		if (isAudio)
		{
			loader = new Sound()
			eventReporter = IEventDispatcher(loader)
		}
		else if (isBinary)
		{
			loader = new Loader()
			eventReporter = loader.contentLoaderInfo
		}
		else
		{
			loader = new URLLoader()
			
			// if one arg then presume its data
			if (rest.length == 1)
			{
				loader.data = processRequestVariables(rest[0])
			}
				// if two args it's data and dataFormat
			else if (rest.length == 2)
			{
				urlRequest.data = processRequestVariables(rest[0])
				loader.dataFormat = rest[1]
			}
			else if (rest.length > 2)
			{
				throw ArgumentError('valid signitures for URLLoader are function(url:String), function(url:String, data:Object), function(url:String, data:Object, dataFormat:String[URLLoaderDataFormat])')	
			}
			
			eventReporter = IEventDispatcher(loader)
		}
		
		const completeHandler:Function = function (e:Event):void {
			removeEvents()
			
			const data:* = (isAudio)
				?	loader
				:	(isBinary)
					? loader.content
					: loader.data
			
			// complete the loading future and map the loaded data to a new type if needed
			future.complete(data)	
		}
		
		const progressHandler:Function = function (e:ProgressEvent):void {
			future.progress(e.bytesTotal / e.bytesLoaded)
		}
		
		const errorHandler:Function = function (e:ErrorEvent):void {
			future.cancel(e)
			if (future.hasIsolatedCancelListener == false)
			{	
				if (e is IOErrorEvent)					
				{
					ioError.message = e.text
					throw ioError
				}
				else if (e is SecurityErrorEvent)		
				{
					securityEvent.message = e.text
					throw securityEvent
				}
			}
		}
		
		const removeEvents:Function = function():void {
			eventReporter.removeEventListener(Event.COMPLETE, completeHandler)
			eventReporter.removeEventListener(ProgressEvent.PROGRESS, progressHandler)
			eventReporter.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler)
			eventReporter.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler)
		}
		
		eventReporter.addEventListener(Event.COMPLETE, completeHandler)
		eventReporter.addEventListener(ProgressEvent.PROGRESS, progressHandler)
		eventReporter.addEventListener(IOErrorEvent.IO_ERROR, errorHandler)
		eventReporter.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler)
		
		const loadArgs:Array = [urlRequest]	
		
		if (isBinary || isAudio)
		{
			if (rest.length == 1)
			{
				loadArgs.push(rest[0])
			}
			else if (rest.length > 1)
			{
				throw ArgumentError('valid signitures for Loader are function(url:String), function(url:String, context:LoaderContext|SoundLoaderContext)')
			}
		}
		
		loader.load.apply(null, loadArgs)	
		
		return future.isolate()
	}
}