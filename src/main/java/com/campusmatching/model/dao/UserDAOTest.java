
package com.campusmatching.model.dao;

import java.sql.SQLException;
import com.campusmatching.model.domain.User;

public class UserDAOTest {

    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();

        try {
            User user = userDAO.findByLoginId("test_member1");

            if (user != null) {
                System.out.println("회원 조회 성공!");
                System.out.println("회원번호: " + user.getUserId());
                System.out.println("로그인 ID: " + user.getLoginId());
                System.out.println("이름: " + user.getUserName());
                System.out.println("이메일: " + user.getEmail());
            } else {
                System.out.println("해당 로그인 ID의 회원이 없습니다.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
