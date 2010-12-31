package net.twitter
{
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import mx.collections.ArrayCollection;
  
  import twitter.api.Twitter;
  import twitter.api.TwitterSearch;
  import twitter.api.data.TwitterStatus;
  import twitter.api.events.TwitterEvent;
  
  import util.ArrayCollectionMap;
  
  [Bindable]
  public class TwitterWorker
  {
    private var twitterAPI:Twitter;
    private var timer:Timer;
    private var _query:TwitterSearch;
    
    public var statuses:ArrayCollectionMap;

    public function TwitterWorker(query:TwitterSearch, interval:Number = 60000)
    {
      twitterAPI = new Twitter();
      twitterAPI.addEventListener(TwitterEvent.ON_SEARCH, onTwitterStatusEvent);

      timer = new Timer(interval, 1);
      timer.addEventListener(TimerEvent.TIMER, onTimer);
      
      statuses = new ArrayCollectionMap();
      this.query = query;
    }

    public function set query(query:TwitterSearch) : void {
      timer.reset();
      statuses.removeAll();
      _query = query;
      update();
    }
    
    public function get interval() : Number {
      return timer.delay;
    }
    
    public function set interval(value:Number) : void {
      timer.delay = interval;
    }
    
    private function update() : void {
      twitterAPI.search(_query);
    }
    
    private function onTimer(event:TimerEvent) : void {
      update();
    }
    
    private function onTwitterStatusEvent(event:TwitterEvent) : void {
      var latestId:Number = 0;
      for each(var status:TwitterStatus in event.data){
        var id:Number = Number(status.id);
        latestId = Math.max(latestId, id);
        statuses.addItem(status);
      }
      statuses.refresh();
      _query.sinceId = String(latestId);
      timer.reset();
      timer.start();
    }
  }
}