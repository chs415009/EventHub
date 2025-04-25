package com.mycompany.EventHub.DAOImpl;

import com.mycompany.EventHub.DAO.CustomerDAO;
import com.mycompany.EventHub.DAO.DAO;
import com.mycompany.EventHub.POJOs.Customer;
import com.mycompany.EventHub.POJOs.Event;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.criteria.*;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class CustomerDAOImpl extends DAO implements CustomerDAO {

    @Override
    public Customer save(Customer customer) {
        return saveEntity(customer);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Customer> findById(Long id) {
        Customer customer = getById(Customer.class, id);
        return Optional.ofNullable(customer);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Customer> findByUsername(String username) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Customer> query = cb.createQuery(Customer.class);
        Root<Customer> root = query.from(Customer.class);
        
        query.select(root).where(cb.equal(root.get("username"), username));
        
        Customer customer = session.createQuery(query).uniqueResult();
        
        return Optional.ofNullable(customer);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Customer> findAll() {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Customer> query = cb.createQuery(Customer.class);
        Root<Customer> root = query.from(Customer.class);
        
        query.select(root);
        
        return session.createQuery(query).getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Customer> findAllByEventId(Long eventId) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Customer> query = cb.createQuery(Customer.class);
        Root<Customer> root = query.from(Customer.class);
        
        // Join with registeredEvents
        Join<Customer, Event> eventJoin = root.join("registeredEvents");
        
        query.select(root).where(cb.equal(eventJoin.get("id"), eventId));
        
        return session.createQuery(query).getResultList();
    }
    
    @Override
    @Transactional(readOnly = true)
    public boolean existsByUsername(String username) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Long> query = cb.createQuery(Long.class);
        Root<Customer> root = query.from(Customer.class);
        
        query.select(cb.count(root)).where(cb.equal(root.get("username"), username));
        
        Long count = session.createQuery(query).getSingleResult();
        
        return count > 0;
    }

    @Override
    @Transactional(readOnly = true)
    public int countCustomersByEventId(Long eventId) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Long> query = cb.createQuery(Long.class);
        Root<Customer> root = query.from(Customer.class);
        
        // Join with registeredEvents
        Join<Customer, Event> eventJoin = root.join("registeredEvents");
        
        query.select(cb.count(root)).where(cb.equal(eventJoin.get("id"), eventId));
        
        Long count = session.createQuery(query).getSingleResult();
        
        return count.intValue();
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isCustomerRegisteredForEvent(Long customerId, Long eventId) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Long> query = cb.createQuery(Long.class);
        Root<Customer> root = query.from(Customer.class);
        
        // Join with registeredEvents
        Join<Customer, Event> eventJoin = root.join("registeredEvents");
        
        query.select(cb.count(root)).where(
            cb.and(
                cb.equal(root.get("id"), customerId),
                cb.equal(eventJoin.get("id"), eventId)
            )
        );
        
        Long count = session.createQuery(query).getSingleResult();
        
        return count > 0;
    }

    @Override
    public void deleteById(Long id) {       
        Customer customer = getById(Customer.class, id);
        if (customer != null) {
            deleteEntity(customer);
        }
    }
    
    @Override
    public void registerForEvent(Long customerId, Long eventId) {
        Customer customer = getById(Customer.class, customerId);
        Event event = getById(Event.class, eventId);

        if (customer != null && event != null) {
        	customer.registerEvent(event);
            saveEntity(customer);
        }
    }
    
    @Override
    public void unregisterFromEvent(Long customerId, Long eventId) {        
        Customer customer = getById(Customer.class, customerId);
        Event event = getById(Event.class, eventId);
        
        if (customer != null && event != null) {
            customer.dropEvent(event);
            saveEntity(customer);
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<Customer> searchByKeyword(String keyword) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Customer> query = cb.createQuery(Customer.class);
        Root<Customer> root = query.from(Customer.class);
        
        String likePattern = "%" + keyword.toLowerCase() + "%";

        Predicate usernamePredicate = cb.like(cb.lower(root.get("username")), likePattern);
        Predicate fullNamePredicate = cb.like(cb.lower(root.get("fullName")), likePattern);
        
        query.select(root).where(cb.or(usernamePredicate, fullNamePredicate));
        
        return session.createQuery(query).getResultList();
    }
}