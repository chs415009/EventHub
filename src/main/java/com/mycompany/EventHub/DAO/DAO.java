package com.mycompany.EventHub.DAO;

import org.hibernate.Session;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public abstract class DAO {
    
//    private static final Configuration cfg = new Configuration();
//    private static final SessionFactory sf = cfg.configure("hibernate.cfg.xml").buildSessionFactory();
//    
//    private static final ThreadLocal<Session> sessionThread = new ThreadLocal<>();
//    
//    protected Session getSession() {
//        Session session = sessionThread.get();
//        if (session == null) {
//            session = sf.openSession();
//            sessionThread.set(session);
//        }
//        return session;
//    }
//    
//    protected void begin() {
//        getSession().beginTransaction();
//    }
//    
//    protected void commit() {
//        getSession().getTransaction().commit();
//    }
//    
//    protected void rollback() {
//        getSession().getTransaction().rollback();
//    }
//    
//    protected void close() {
//        Session session = sessionThread.get();
//        if (session != null) {
//            session.close();
//            sessionThread.remove();
//        }
//    }
    
    @PersistenceContext
    protected EntityManager entityManager;
    
    protected Session getSession() {
        return entityManager.unwrap(Session.class);
    }
    
  //general CRUD methods for all entities
    protected <T> T saveEntity(T entity) {
	    getSession().saveOrUpdate(entity);
	    return entity;
    }

    protected <T> T getById(Class<T> entityClass, Long id) {
    return getSession().get(entityClass, id);
    }

    protected <T> void deleteEntity(T entity) {
    	getSession().delete(entity);
    }
}