package net.twitter
{
  import mx.formatters.Formatter;
  import twitter.api.data.TwitterStatus;
  import util.StringUtil;
  
  public class TwitterStatusFormatter extends Formatter
  {
    public function TwitterStatusFormatter()
    {
      super();
    }
   
    override public function format(value:Object) : String {
      var status:TwitterStatus = value as TwitterStatus;
      var name:String = status.user.screenName;
      return StringUtil.link("event:" + name, name) + " " + formatBody(status.text);
    }
    
    private function formatBody(text:String) : String {
      return text.replace(/@(\w+)/g, '@<a href="event:$1">$1</a>');
    }
  }
}