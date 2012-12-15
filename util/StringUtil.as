package util
{
	public class StringUtil
	{
	  public static function replaceLink(s:String) : String {
       var pattern:RegExp = /https?:\/\/[-_.!~*'()\w;\/?:@&=+$,%#]+/gi;
       var markup:String = "<u><a href=\"$&\" target='blank'>$&</a></u>"
       return s.replace(pattern, markup);
	  }
    
    public static function replaceLinkShort(s:String) : String {
        var pattern:RegExp = /https?:\/\/([-_.!~*'()\w;\/?:@&=+$,%#]+)/gi;
        return s.replace(pattern, shortenURL);
    }
    
    public static function shortenURL(url:String, urlBody:String, index:int, s:String) : String {
        var urlView:String = urlBody.length > 18 ? urlBody.substr(0, 18) + ".." : urlBody;
        return "<u><a href='" + url + "' target='blank'>" + urlView + "</a></u>";
    }

	  public static function link(href:String, body:String) : String {
	    return '<a href="' + href + '">' + body + '</a>'
	  }
	  
	  public static function htmlEscape(s:String) : String {
	    s = s.replace(/&/g, '&amp;');
      s = s.replace(/</g, '&lt;').replace(/>/g, '&gt;');
      s = s.replace(/\'/g, '&#39;').replace(/\"/g, '&quot;');
     return s;
	  }

		public static function intervalToString(t:Number) : String {
			var array:Array = [t / 3600000, t / 60000 % 60, t / 1000 % 60];
			
			return array.map(function(n:*, i:int, a:Array) : String{
				return n < 10 ? "0" + int(n).toString() : int(n).toString();
			}).join(":");
		}
	}
}