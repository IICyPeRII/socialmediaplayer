package SocialMediaPlayer
{
	import mx.core.Application;
	
	public class SettingsManager
	{
		private var SQLConn:SQLiteConnector = Application.application.SQLConn;
		private var sql:String;
		// Media Paths
		public function set MediaPath(val:String):void {
			sql = 	"	UPDATE 	Settings " + 
					"	SET			value = :param1 " +
					"	WHERE		param = 'MediaPath'";
			SQLConn.DoSQL(sql, val);
		}
		public function get MediaPath():String {
			sql =	"	SELECT		value "+
					"	FROM 		Settings "+
					"	WHERE 		param = 'MediaPath'";
			return SQLConn.FetchOne(sql); 
		}
		// Twitter
		public function set twitter_user(val:String):void {
			sql = 	" 	UPDATE		Settings " +
					"	SET			value = :param1 " +
					"	WHERE		param = 'twitter_user'";
			SQLConn.DoSQL(sql, val);
		}
		public function get twitter_user():String {
			sql =	"	SELECT 	value " +
					"	FROM 		Settings " +
					"	WHERE 		param = 'twitter_user'"
			return SQLConn.FetchOne(sql);
		}
		public function set twitter_password(val:String):void {
			sql = 	" 	UPDATE		Settings " +
					"	SET			value = :param1 " +
					"	WHERE		param = 'twitter_password'";
			SQLConn.DoSQL(sql, val);
		}
		public function get twitter_password():String {
			sql = 	"	SELECT 	value " + 
					"	FROM 		Settings " + 
					"	WHERE 		param = 'twitter_password'";
			return SQLConn.FetchOne(sql);
		}

	}
}