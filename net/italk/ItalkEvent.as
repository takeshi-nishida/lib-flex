package net.italk
{
  import flash.events.Event;

  public class ItalkEvent extends Event
  {
    public static const LOG_RECEIVED:String = "logReceived";

    public var line:String;

    public function ItalkEvent(type:String, line:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
      this.line = line;
    }
        
    override public function clone() : Event {
      return new ItalkEvent(type, line);
    }
  }
}