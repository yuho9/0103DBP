
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

    public boolean register(String loginId, String password,
                            String userName, String email,
                            String phone) throws SQLException {

        if (loginId == null || loginId.isBlank()
                || password == null || password.isBlank()
                || userName == null || userName.isBlank()
                || email == null || email.isBlank()) {
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

        User user = new User(
            null,
            loginId,
            passwordHash,
            userName,
            email,
            phone,
            null
        );

        return userDAO.create(user) == 1;
    }
}
