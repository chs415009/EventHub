package com.mycompany.EventHub.DAOImpl;

import com.mycompany.EventHub.DAO.DAO;
import com.mycompany.EventHub.DAO.UserDAO;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository
@Transactional
public class UserDAOImpl extends DAO implements UserDAO {

}