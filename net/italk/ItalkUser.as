package net.italk
{
  public class ItalkUser
  {
    public var id:int;
    public var handle:String;
    public var status:String;
    
    public function ItalkUser(userno:int, handle:String, status:String)
    {
      this.id = userno;
      this.handle = handle;
      this.status = status;
    }
  }
}