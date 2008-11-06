// GNU GPL License - 2008
//----------------------------------------------
//        Villagrán & Quiroz
//   http://www.villagranquiroz.cl
package SocialMediaPlayer
{
	import flash.errors.SQLError;
	
	public class SQLiteConnector {
		import flash.data.SQLConnection;
		import flash.data.SQLMode;
		import flash.data.SQLStatement;
		import flash.data.SQLResult;
		import flash.events.SQLErrorEvent;
		import flash.events.SQLEvent;
		import flash.filesystem.File;
		import mx.utils.ObjectUtil;

		private var conn:SQLConnection;
		private var dbFile:File;
		public function SQLiteConnector() {
			conn = new SQLConnection;
		}
		// Get & Set
		public function get sqlConnector():SQLConnection { return conn; }
		public function set DbFile(setValue:String):void {
			if(!File.documentsDirectory.resolvePath(setValue).exists) {
				File.applicationDirectory.resolvePath(setValue).copyTo(File.documentsDirectory.resolvePath(setValue), true);
			}
			dbFile = File.documentsDirectory.resolvePath(setValue);
		}
		// Functions
		public function Connect():void {
			try {
				conn.open(dbFile, SQLMode.UPDATE);
			} catch(error:SQLError) {
				trace("Error message:", error.message);
    			trace("Details:", error.details);
			}
		}
		public function Disconnect():void {
			try {
				conn.close();
			} catch(error:SQLError) {
				trace("Error message:", error.message);
    			trace("Details:", error.details);
			}
			
		}
		public function DoSQL(sql:String, param1:String = ""):SQLResult {
			Connect();
			
			var statement:SQLStatement = new SQLStatement();
			
			statement.sqlConnection = conn;
			statement.text = sql;
			
			try {
				if(param1 != "")
					statement.parameters[":param1"] = param1;				
				statement.execute();
				var result:SQLResult = statement.getResult() 

			} catch(error:SQLError) {
				trace("Error message:", error.message);
    			trace("Details:", error.details);
			}
			Disconnect();
			if(result != null)
				return result;
			
			return null;
		}
		public function FetchOne(sql:String, param1:String = ""):String {
			var result:SQLResult = DoSQL(sql, param1);
			
			for (var i:int = 0; i < result.data.length; i++) {
        		for (var columnName:String in result.data[i]) {
            		return result.data[i][columnName];
        		}	
        
    		}

			return null;
		}
		public function FetchArray(sql:String, param1:String = ""):Array {
			var result:SQLResult = DoSQL(sql, param1);
			return result.data;
		}
	}
}
