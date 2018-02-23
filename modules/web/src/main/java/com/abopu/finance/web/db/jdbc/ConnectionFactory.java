package com.abopu.finance.web.db.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * @author Sarah Skanes
 * @created May 14, 2017.
 */
public class ConnectionFactory {
	
	public static Connection getWebConnection() throws SQLException {
		return DriverManager.getConnection("jdbc:postgresql://centos3:5432/finance");
	}
}
