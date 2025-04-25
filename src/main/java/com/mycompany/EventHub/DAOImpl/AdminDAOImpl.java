package com.mycompany.EventHub.DAOImpl;

import com.mycompany.EventHub.DAO.AdminDAO;
import com.mycompany.EventHub.DAO.DAO;
import com.mycompany.EventHub.POJOs.Admin;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import java.util.List;
import java.util.Optional;

@Repository
public class AdminDAOImpl extends DAO implements AdminDAO {

    @Override
    public Admin save(Admin admin) {
        return saveEntity(admin);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Admin> findByUsername(String username) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Admin> query = cb.createQuery(Admin.class);
        Root<Admin> root = query.from(Admin.class);
        
        query.select(root).where(cb.equal(root.get("username"), username));
        
        Admin admin = session.createQuery(query).uniqueResult();
        
        return Optional.ofNullable(admin);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Admin> findAll() {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Admin> query = cb.createQuery(Admin.class);
        Root<Admin> root = query.from(Admin.class);
        
        query.select(root);
        
        return session.createQuery(query).getResultList();
    }
}