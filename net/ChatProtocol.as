package net
{
	import flash.events.DataEvent;
	import flash.events.Event;
	
	public class ChatProtocol
	{
		public static const COMMAND_PREFIX:String	= "/";
		public static const EVENT_PREFIX:String		= "#";
		public static const END_HEADER:String			= " >> ";
		public static const SEPARATOR:String			= " ";
		
		private var _chat : Object;
		private var _connection : UTFLineConnection;

		public function ChatProtocol(chat : Object) {
			_chat = chat;
		}
		
		public function get connection() : UTFLineConnection {
		  return _connection ? _connection : createConnection() ;
		}
				
		public function login(loginLine:String, host:String, port:int) : void {
		  if(!_connection){
		    createConnection();
		  }
      _connection.writeOnConnect = loginLine;
      _connection.connect(host, port);
		}
		
		public function sendCommandLine(commandName:String, args:Array) : void {
		  if(_connection){
		    _connection.writeln(COMMAND_PREFIX + commandName + SEPARATOR + args.join(SEPARATOR));
		  }
    }
    
    public function sendMessageLine(message:String, args:Array) : void {
      if(_connection){
        _connection.writeln(args.join(SEPARATOR) + END_HEADER + message);      
      }
    }
		
		public function lineReceived(e:DataEvent) : void {
			trace(e.data);
			process(e.data);
		}
		
		public function process(s:String) : void {
      var i:int;
      
      if(s.lastIndexOf(EVENT_PREFIX, 0) == 0){
        i = s.indexOf(SEPARATOR);
        if(i > 0){
          processEvent(s.substring(1, i), s.substring(i + SEPARATOR.length));
        }
        else{
          processEvent(s.substring(1), null);
        }
      }
      else{
        i = s.indexOf(END_HEADER);
        if(i > 0){
          processLine(s.substring(0, i), s.substring(i + END_HEADER.length));
        }
        else{
          processLine(null, s);
        }
      }		  
		}
				
		public function connectionClosed(e:Event) : void {
		  _connection = null;
		  _chat.connectionClosed();
		}
		
		private function createConnection() : UTFLineConnection {
		  _connection = new UTFLineConnection();
		  _connection.addEventListener(DataEvent.DATA, lineReceived);
		  _connection.addEventListener(Event.CLOSE, connectionClosed);
		  return _connection;
		}
						
		private function processLine(header:String, message:String) : void {
			trace("Line[header=" + header + "&message=" + message + "]");
			try{
				_chat.processLine(header, message);
			}
			catch(e:ReferenceError){
				trace(e);
			}
		}
		
		private function processEvent(name:String, args:String) : void {
			trace("Event[name=" + name + "&args=" + args + "]");
			try{
				_chat[name](args);
			}
			catch(e:ReferenceError){
				trace(e);
			}
		}
		
	}
}