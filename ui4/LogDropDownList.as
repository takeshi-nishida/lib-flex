package ui4
{
    import spark.components.DropDownList;
    
    public class LogDropDownList extends DropDownList
    {
        public function LogDropDownList()
        {
            super();
        }
        
        override protected function itemAdded(index:int) : void {
            super.itemAdded(index);
            selectedIndex = index;
        }
    }
}