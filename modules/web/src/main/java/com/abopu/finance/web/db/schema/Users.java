package com.abopu.finance.web.db.schema;

import com.abopu.data.dao.ColumnDefinition;
import com.abopu.finance.common.beans.User;

import java.sql.JDBCType;
import java.sql.ResultSet;
import java.sql.SQLType;

/**
 * @author Sarah Skanes
 * @created July 13, 2017.
 */
public class Users {
	
	public enum Columns implements ColumnDefinition<User> {
		ID(JDBCType.BIGINT),
		NAME(JDBCType.VARCHAR),
		PASSWORD(JDBCType.VARCHAR),
		LAST_LOGIN(JDBCType.TIMESTAMP);
		
		private SQLType sqlType;
				
		Columns(SQLType sqlType) {
			this.sqlType = sqlType;
		}
		
		public SQLType sqlType() {
			return sqlType;
		}

		public long getValue(ResultSet rs) {
			return 0;
		}
	}
}
