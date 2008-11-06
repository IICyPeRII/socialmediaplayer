package SocialMediaPlayer
{
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.EventPriority;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;
	
	public class MediaDataGrid extends DataGrid
	{
		public function MediaDataGrid()
		{
			super();
			doubleClickEnabled = true;
		}


	}
}