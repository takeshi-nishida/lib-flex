package net.italk
{
  import com.web2memo.text.Jcode;
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.events.ProgressEvent;
  import flash.net.Socket;
  import flash.utils.ByteArray;
  
  import util.ArrayCollectionMap;

  [Bindable]
  [Event(name="logReceived", type="net.italk.ItalkEvent")]
  public class ItalkProtocol extends EventDispatcher
  {
    ///////////////////////////////////////////////////////////////////////////
    // Log patterns
    ///////////////////////////////////////////////////////////////////////////
    public static const sectionPattern:RegExp = /^#! <\/?([^\/]+)>$/;
    public static const infoPattern:RegExp = /^#! ([^=]+)=(.*)$/;

    ///////////////////////////////////////////////////////////////////////////
    // Data model
    ///////////////////////////////////////////////////////////////////////////
    
    public var users:ArrayCollectionMap;

    ///////////////////////////////////////////////////////////////////////////
    // Private variables
    ///////////////////////////////////////////////////////////////////////////    

    private var socket:Socket;
    private var buffer:String;
    private var _handle:String;
    private var sectionData:Object;
    private var sectionType:String;

    private var lineHandler:Function = handleFirstLine;
    private const sectionHandler:Object = { 
      user:userSection, newuser:userSection
    };
    private const diffHandler:Object = {
      newhandle:updateHandle, newstatus:updateStatus, logout:removeUser, disconnect:removeUser
    };

    ///////////////////////////////////////////////////////////////////////////
    // Initialize
    ///////////////////////////////////////////////////////////////////////////
    
    public function ItalkProtocol(target:IEventDispatcher=null)
    {
      socket = new Socket();
      socket.addEventListener(Event.CONNECT, handleConnect);
      socket.addEventListener(Event.CLOSE, handleClose);
      socket.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
    }
    
    public function login(handle:String, host:String, port:int) : void {
      users = new ArrayCollectionMap();
      _handle = handle;
      buffer = "";
      socket.connect(host, port);
    }

    ///////////////////////////////////////////////////////////////////////////
    // Send
    ///////////////////////////////////////////////////////////////////////////
    
    public function send(line:String) : void {
      var bytes:ByteArray = Jcode.getInstance().UTF8toEUC(line + "\n");
      socket.writeBytes(bytes, 0, bytes.length);
//      socket.writeMultiByte(line + "\r\n", charSet);
      socket.flush();
    }
    
    public function changeHandle(handle:String) : void {
      send("/h " + _handle);
    }

    ///////////////////////////////////////////////////////////////////////////
    // Line handlers
    ///////////////////////////////////////////////////////////////////////////
    
    private function handleFirstLine(line:String) : void {
      send("/x type=mixed");
      send("/wa");
      changeHandle(_handle);
      lineHandler = handleLine;
      dispatchEvent(new ItalkEvent(ItalkEvent.LOG_RECEIVED, line));      
    }
    
    private function handleLine(line:String) : void {
      if(line.charAt(0) == "#"){
        handleSystemLine(line);
      }
      else{
        dispatchEvent(new ItalkEvent(ItalkEvent.LOG_RECEIVED, line));      
      }
    }
    
    private function handleSystemLine(line:String) : void {
      var result:Object;

      result = sectionPattern.exec(line);
      if(result){
        sectionType = result[1];
        if(sectionType != "italk"){
          sectionData = new Object();
          lineHandler = handleSection;
        }
        return;
      }

      result = infoPattern.exec(line);
      if(result){
        if(diffHandler[result[1]]){
          diffHandler[result[1]](result[2]);
        }
        return;
      }

      dispatchEvent(new ItalkEvent(ItalkEvent.LOG_RECEIVED, line));      
    }
    
    private function handleSection(line:String) : void {
      if(sectionPattern.test(line)){
        if(sectionHandler[sectionType]){
          sectionHandler[sectionType](sectionData);
        }
        lineHandler = handleLine;
      }
      else{
        var result:Object = infoPattern.exec(line);
        sectionData[result[1]] = result[2];
      }
    }
    
    // Sections ---------------------------------------------------------------
    
    private function userSection(data:Object) : void {
      users.addItem(new ItalkUser(parseInt(data.userno), data.handle, data.status));
    }
    
    // Updates ----------------------------------------------------------------
    
    private function updateHandle(value:String) : void {
      var params:Array = value.split(",");
      var id:int = parseInt(params[0]);
      var user:ItalkUser = users.getItem(id) as ItalkUser;
      
      user.handle = params[1];
      users.itemUpdated(user, "handle");
    }
    
    private function updateStatus(value:String) : void {
      var params:Array = value.split(",");
      var id:int = parseInt(params[0]);
      var user:ItalkUser = users.getItem(id) as ItalkUser;
      
      user.status = params[1];
      users.itemUpdated(user, "status");
    }
    
    private function removeUser(value:String) : void {
      users.removeItem(parseInt(value));
    }
     
    ///////////////////////////////////////////////////////////////////////////
    // Event Handlers
    ///////////////////////////////////////////////////////////////////////////
    
    private function handleConnect(event:Event) : void {
      // Nothing to do
    }
    
    private function handleClose(event:Event) : void {
      dispatchEvent(event);
    }
    
    private function handleSocketData(event:ProgressEvent) : void {
      //buffer += socket.readMultiByte(socket.bytesAvailable, charSet);
      var bytes:ByteArray = new ByteArray();
      socket.readBytes(bytes, 0, socket.bytesAvailable);
      buffer += Jcode.getInstance().EUCtoUTF8(bytes);
      
      var n:int = buffer.lastIndexOf("\r\n");
      if(n > 0){
        var lines:Array = buffer.substring(0, n).split("\r\n");
        for each(var line:String in lines){
          lineHandler(line);
        }
        buffer = buffer.substring(Math.min(n + 2, buffer.length));
      }
    }
  }
}