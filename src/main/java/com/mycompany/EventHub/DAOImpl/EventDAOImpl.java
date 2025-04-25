package com.mycompany.EventHub.DAOImpl;

import com.mycompany.EventHub.DAO.DAO;
import com.mycompany.EventHub.DAO.EventDAO;
import com.mycompany.EventHub.POJOs.Customer;
import com.mycompany.EventHub.POJOs.Event;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.criteria.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class EventDAOImpl extends DAO implements EventDAO {

    @Override
    public Event save(Event event) {
        return saveEntity(event);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Event> findById(Long id) {
        Event event = getById(Event.class, id);
        return Optional.ofNullable(event);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Event> findAll() {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Event> query = cb.createQuery(Event.class);
        Root<Event> root = query.from(Event.class);
        
        query.select(root);
        
        return session.createQuery(query).getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Event> findByOrganizerId(Long organizerId) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Event> query = cb.createQuery(Event.class);
        Root<Event> root = query.from(Event.class);
        
        query.select(root).where(cb.equal(root.get("organizer").get("id"), organizerId));
        
        return session.createQuery(query).getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Event> findByCategory(String category) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Event> query = cb.createQuery(Event.class);
        Root<Event> root = query.from(Event.class);
        
        query.select(root).where(cb.equal(root.get("category"), category));
        
        return session.createQuery(query).getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Event> findPastEvents(LocalDateTime now) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Event> query = cb.createQuery(Event.class);
        Root<Event> root = query.from(Event.class);
        
        query.select(root)
             .where(cb.lessThan(root.get("eventDate"), now))
             .orderBy(cb.desc(root.get("eventDate")));
        
        return session.createQuery(query).getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Event> searchByKeyword(String keyword) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Event> query = cb.createQuery(Event.class);
        Root<Event> root = query.from(Event.class);
        
        String likePattern = "%" + keyword.toLowerCase() + "%";
        
        Predicate titlePredicate = cb.like(cb.lower(root.get("title")), likePattern);
        Predicate descriptionPredicate = cb.like(cb.lower(root.get("description")), likePattern);
        Predicate categoryPredicate = cb.like(cb.lower(root.get("category")), likePattern);
        
        query.select(root).where(cb.or(titlePredicate, descriptionPredicate, categoryPredicate));
        
        return session.createQuery(query).getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public int countRegisteredCustomers(Long eventId) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Long> query = cb.createQuery(Long.class);
        Root<Event> root = query.from(Event.class);
        
        // Join with registeredCustomers
        Join<Event, Customer> customerJoin = root.join("registeredCustomers", JoinType.LEFT);
        
        query.select(cb.count(customerJoin))
             .where(cb.equal(root.get("id"), eventId));
        
        Long count = session.createQuery(query).getSingleResult();
        
        return count.intValue();
    }

    @Override
    public void deleteById(Long id) {
        Event event = getById(Event.class, id);
        if (event != null) {
            deleteEntity(event);
        }
    }
}