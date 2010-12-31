package net.twitter
{
  import flash.events.HTTPStatusEvent;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLStream;
  import flash.net.URLVariables;
  
  [Bindable]
  public class TwitterStream
  {
    private const request:URLRequest = new URLRequest("http://stream.twitter.com/1/statuses/filter.xml"); 

    private var _users:String;
    private var _keywords:String;

    private var stream:URLStream;
    private var buffer:String;
    
    public function TwitterStream(){
      request.method = URLRequestMethod.POST;
    }
    
    public function set users(a:Array) : void {
      _users = (a && a.length > 0) ? a.join(",") : null;
      connect();
    }
    
    public function set keywords(a:Array) : void {
      _keywords = (a && a.length > 0) ? a.join(",") : null;
      connect();
    }

    public function connect() : void {
      if(stream){
        stream.close();
      }

      buffer = "";
      request.data = buildVariables();

      stream = new URLStream();
      stream.addEventListener(ProgressEvent.PROGRESS, progressHandler);
      stream.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
      stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
      stream.load(request);
    }
        
    ///////////////////////////////////////////////////////////////////////////
    // Received data handlers
    ///////////////////////////////////////////////////////////////////////////
    
    private function progressHandler(event:ProgressEvent) : void {
      trace(stream.readUTFBytes(stream.bytesAvailable));
//      var len:uint = stream.readUnsignedInt();
//      var status:XML = new XML(stream.readUTFBytes(len));
    }
        
    ///////////////////////////////////////////////////////////////////////////
    // Other Event handlers
    ///////////////////////////////////////////////////////////////////////////
    
    private function httpStatusHandler(event:HTTPStatusEvent) : void {
      trace(event.status);
    }
    
    private function ioErrorHandler(event:IOErrorEvent) : void {
      trace(event.text);
    }    
    
    ///////////////////////////////////////////////////////////////////////////
    // Other private functions
    ///////////////////////////////////////////////////////////////////////////
    private function buildVariables() : URLVariables {
      var variables:URLVariables = new URLVariables();
      variables.delimited = "length";
      variables.count = 100; // for now
      if(_users){
        variables.follow = _users;
      }
      if(_keywords){
        variables.track = _keywords;
      }
      return variables;
    }

  }
}