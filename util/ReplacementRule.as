package util
{
  public class ReplacementRule
  {
    public var pattern:RegExp;
    public var repl:String;

    public function ReplacementRule(pattern:RegExp, repl:String)
    {
      this.pattern = pattern;
      this.repl = repl;
    }
    
    public function process(s:String) : String {
      return s.replace(pattern, repl);
    }
    
    public static function processRules(s:String, rules:Array) : String {
      for each(var rule:ReplacementRule in rules){
        s = rule.process(s);
      }
      return s;
    }
  }
}