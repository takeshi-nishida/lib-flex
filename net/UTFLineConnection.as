package net
{
    import flash.errors.IOError;
    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.net.Socket;

    public class UTFLineConnection extends EventDispatcher
    {
        private var socket:Socket;
        private var buffer:String;
        private var _writeOnConnect:String;
        
        public function UTFLineConnection(){
            socket = new Socket();
            socket.addEventListener(Event.CONNECT, connectHandler);
            socket.addEventListener(Event.CLOSE, closeHandler);
            socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
        }
        
        public function set writeOnConnect(s:String) : void {
        	_writeOnConnect = s;
        }

        public function connect(host:String, port:int) : void{
            try{
                socket.connect(host, port);
                buffer = "";
            }
            catch(e:Error){
                trace(e);
            }
        }
                
        public function writeln(s:String) : void{
            try{
                socket.writeUTFBytes(s + "\n");
                socket.flush();
            }
            catch(e:IOError){
                trace(e);
            }
        }
        
        private function socketDataHandler(event:ProgressEvent) : void{
            trace(event);

            buffer += socket.readUTFBytes(socket.bytesAvailable);
            var n:int = buffer.lastIndexOf("\n");
            if(n > 0){
                var lines:Array = buffer.substring(0, n).split("\n");
                for each(var line:String in lines){
                    dispatchEvent(new DataEvent(DataEvent.DATA, false ,false, line));
                }
                buffer = buffer.substring(Math.min(n + 1, buffer.length));
            }
        }
        
        private function connectHandler(event:Event) : void{
            trace(event);
            if(_writeOnConnect){
            	writeln(_writeOnConnect);
            }
        }
        
        private function closeHandler(event:Event) : void {
          trace(event);
          dispatchEvent(event);
        }
    }
}