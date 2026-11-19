
package com.campusmatching.model.service;

import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

import com.campusmatching.model.dao.UserDAO;
import com.campusmatching.model.domain.User;

public class UserManager {

	private final UserDAO userDAO = new UserDAO();

	public User login(String loginId, String password) throws SQLException {
		User user = userDAO.findByLoginId(loginId);

		if (user == null) {
			return null;
		}

		if (!user.matchPassword(password)) {
			return null;
		}

		return user;
	}

	public boolean existsLoginId(String loginId) throws SQLException {
		return userDAO.existsLoginId(loginId);
	}

	public boolean existsEmail(String email) throws SQLException {
		return userDAO.existsEmail(email);
	}

	public boolean register(String loginId, String password, String userName, String email, String phone)
			throws SQLException {

		if (loginId == null || loginId.isBlank() || password == null || password.isBlank() || userName == null
				|| userName.isBlank() || email == null || email.isBlank()) {
			throw new IllegalArgumentException("필수 입력값이 누락되었습니다.");
		}

		loginId = loginId.trim();
		userName = userName.trim();
		email = email.trim();
		phone = phone == null ? null : phone.trim();

		if (userDAO.existsLoginId(loginId)) {
			throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
		}

		if (userDAO.existsEmail(email)) {
			throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
		}

		String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(12));

		User user = new User(null, loginId, passwordHash, userName, email, phone, null);

		return userDAO.create(user) == 1;
	}

	public User findById(Long userId) throws SQLException {
		if (userId == null) {
			throw new IllegalArgumentException("회원번호가 필요합니다.");
		}

		return userDAO.findById(userId);
	}

	public boolean updateUserInfo(Long userId, String email, String phone) throws SQLException {

		if (userId == null) {
			throw new IllegalArgumentException("로그인이 필요합니다.");
		}

		if (email == null || email.isBlank()) {
			throw new IllegalArgumentException("이메일을 입력해 주세요.");
		}

		email = email.trim();
		phone = phone == null ? null : phone.trim();

		if (email.length() > 255 || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
			throw new IllegalArgumentException("이메일 형식이 올바르지 않습니다.");
		}

		if (phone != null && !phone.isEmpty()) {
			if (phone.length() > 20 || !phone.matches("^\\d{2,3}-\\d{3,4}-\\d{4}$")) {
				throw new IllegalArgumentException("전화번호 형식이 올바르지 않습니다.");
			}
		} else {
			phone = null;
		}

		User currentUser = userDAO.findById(userId);

		if (currentUser == null) {
			throw new IllegalArgumentException("회원정보를 찾을 수 없습니다.");
		}

		if (!currentUser.getEmail().equals(email) && userDAO.existsEmail(email)) {
			throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
		}

		return userDAO.updateUserInfo(userId, email, phone) == 1;
	}
	

public boolean changePassword(Long userId,
                              String currentPassword,
                              String newPassword,
                              String confirmPassword) throws SQLException {

    if (userId == null) {
        throw new IllegalArgumentException("로그인이 필요합니다.");
    }

    if (currentPassword == null || currentPassword.isEmpty()
            || newPassword == null || newPassword.isEmpty()
            || confirmPassword == null || confirmPassword.isEmpty()) {
        throw new IllegalArgumentException("모든 비밀번호를 입력해 주세요.");
    }

    User user = userDAO.findById(userId);

    if (user == null) {
        throw new IllegalArgumentException("회원정보를 찾을 수 없습니다.");
    }

    if (!user.matchPassword(currentPassword)) {
        throw new IllegalArgumentException("현재 비밀번호가 올바르지 않습니다.");
    }

    if (!newPassword.equals(confirmPassword)) {
        throw new IllegalArgumentException("새 비밀번호가 일치하지 않습니다.");
    }

    if (newPassword.length() < 8
            || !newPassword.matches("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[^A-Za-z0-9\\s])\\S{8,}$")) {
        throw new IllegalArgumentException(
            "비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상 입력해 주세요.");
    }

    if (newPassword.getBytes(java.nio.charset.StandardCharsets.UTF_8).length > 72) {
        throw new IllegalArgumentException("비밀번호가 너무 깁니다.");
    }

    if (currentPassword.equals(newPassword)) {
        throw new IllegalArgumentException(
            "현재 비밀번호와 다른 비밀번호를 입력해 주세요.");
    }

    String newPasswordHash = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));

    return userDAO.updatePassword(
        userId,
        user.getPasswordHash(),
        newPasswordHash
    ) == 1;
}


public boolean withdraw(Long userId, String password)
        throws SQLException {

    if (userId == null) {
        throw new IllegalArgumentException("로그인이 필요합니다.");
    }

    if (password == null || password.isEmpty()) {
        throw new IllegalArgumentException("현재 비밀번호를 입력해 주세요.");
    }

    User user = userDAO.findById(userId);

    if (user == null) {
        throw new IllegalArgumentException("회원정보를 찾을 수 없습니다.");
    }

    if (!user.matchPassword(password)) {
        throw new IllegalArgumentException("현재 비밀번호가 올바르지 않습니다.");
    }

    return userDAO.withdraw(userId, user.getPasswordHash()) == 1;
}

}
