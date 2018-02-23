package com.abopu.finance.web.db.dao;

import com.abopu.data.bind.BindObjects;
import com.abopu.data.dao.AbstractDAO;
import com.abopu.data.dao.DaoFilter;
import com.abopu.data.dao.exception.DaoException;
import com.abopu.finance.common.beans.User;
import com.abopu.finance.common.util.ObjectCloner;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Collection;
import java.util.Map;

import static com.abopu.finance.web.db.schema.Users.Columns.ID;
import static com.abopu.finance.web.db.schema.Users.Columns.LAST_LOGIN;
import static com.abopu.finance.web.db.schema.Users.Columns.NAME;


/**
 * @author Sarah Skanes
 * @created May 14, 2017.
 */
public class UserDao extends AbstractDAO<User, Long> {

	/***************************************************************************
	 *
	 * SQL Statements
	 *
	 **************************************************************************/

	private static final String SQL_CREATE_USER = "INSERT INTO users (name, password, last_login) VALUES ?, ?, null";
	private static final String SQL_DELETE_USER = "DELETE FROM users WHERE id = ?";
	private static final String SQL_GET_ALL_USERS = "SELECT * FROM users";
	private static final String SQL_GET_USER = "SELECT * FROM users WHERE id = ?";
	private static final String SQL_UPDATE_USER = "UPDATE users SET name = ?, password = ?, last_login = ? WHERE id = ?";
	


	/***************************************************************************
	 *
	 * Implementation: DAO
	 *
	 **************************************************************************/

	/**
	 * {@inheritDoc}
	 *
	 * @param conn
	 * @param object record to persist
	 * @return
	 * @throws DaoException
	 */
	@Override
	public User create(Connection conn, User object) throws DaoException {
		Long id;
		try (PreparedStatement ps = conn.prepareStatement(SQL_CREATE_USER, Statement.RETURN_GENERATED_KEYS)) {
			ps.setString(1, object.getUsername());
			ps.setString(2, object.getHashedPassword());
			ps.executeUpdate();

			try (ResultSet rs = ps.getGeneratedKeys()) {
				id = rs.getLong(1);
			}

			return ObjectCloner.clone(object);
		} catch (Exception e) {
			throw new DaoException("foo", e);
		}
	}

	/**
	 * {@inheritDoc}
	 *
	 * @param conn
	 * @param id   id of record to remove
	 * @return
	 * @throws DaoException
	 */
	@Override
	public boolean delete(Connection conn, Long id) throws DaoException {
		try (PreparedStatement ps = conn.prepareStatement(SQL_DELETE_USER)) {
			ps.setLong(1, id);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			throw new DaoException("foo", e);
		}
	}

	/**
	 * {@inheritDoc}
	 *
	 * @param conn
	 * @param filter
	 * @return
	 * @throws DaoException
	 */
	@Override
	public Collection<User> get(Connection conn, DaoFilter<User> filter) throws DaoException {
		try (PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL_USERS)) {

		} catch (SQLException e) {
			throw new DaoException("foo", e);
		}
	}

	@Override
	public User get(Connection conn, Long id) throws DaoException {
		try (PreparedStatement ps = conn.prepareStatement(SQL_GET_USER)) {
			ps.setLong(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				return processResults(rs, this::createObject).stream().findFirst().orElseThrow(() -> new DaoException("foo"));
			}
		} catch (Exception e) {
			throw new DaoException("foo", e);
		}
	}

	@Override
	public boolean update(Connection conn, User object, BindObjects bindObjects) throws DaoException {
		try (PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_USER)) {

		} catch (SQLException e) {
			throw new DaoException("foo", e);
		}
	}



	/***************************************************************************
	 *
	 * Private API
	 *
	 **************************************************************************/

	private User createObject(ResultSet rs) throws SQLException {
		User user = new User(rs.getLong(ID));
		user.setUsername(rs.getString(NAME));
		user.setLastLogin(rs.getTimestamp(LAST_LOGIN));

		return user;
	}

}
