
package com.campusmatching.model.domain;

import java.time.LocalDateTime;

import org.mindrot.jbcrypt.BCrypt;

public class User {

    private Long userId;
    private String loginId;
    private String passwordHash;
    private String userName;
    private String email;
    private String phone;
    private LocalDateTime createdAt;

    public User() {
    }

    public User(Long userId, String loginId, String passwordHash,
                String userName, String email, String phone,
                LocalDateTime createdAt) {
        this.userId = userId;
        this.loginId = loginId;
        this.passwordHash = passwordHash;
        this.userName = userName;
        this.email = email;
        this.phone = phone;
        this.createdAt = createdAt;
    }

    public void update(User updateUser) {
        this.userName = updateUser.userName;
        this.email = updateUser.email;
        this.phone = updateUser.phone;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean matchPassword(String password) {
        if (password == null || this.passwordHash == null) {
            return false;
        }

        return BCrypt.checkpw(password, this.passwordHash);
    }

    public boolean isSameUser(Long userId) {
        return this.userId != null && this.userId.equals(userId);
    }

    @Override
    public String toString() {
        return "User [userId=" + userId
                + ", loginId=" + loginId
                + ", userName=" + userName
                + ", email=" + email
                + ", phone=" + phone
                + ", createdAt=" + createdAt + "]";
    }
}
