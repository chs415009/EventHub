package com.mycompany.EventHub.DAOImpl;

import com.mycompany.EventHub.DAO.DAO;
import com.mycompany.EventHub.DAO.OrganizerDAO;
import com.mycompany.EventHub.POJOs.Event;
import com.mycompany.EventHub.POJOs.Organizer;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class OrganizerDAOImpl extends DAO implements OrganizerDAO {

    @Override
    public Organizer save(Organizer organizer) {
        return saveEntity(organizer);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Organizer> findById(Long id) {
        Organizer organizer = getById(Organizer.class, id);
        return Optional.ofNullable(organizer);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Organizer> findByUsername(String username) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Organizer> query = cb.createQuery(Organizer.class);
        Root<Organizer> root = query.from(Organizer.class);
        
        query.select(root).where(cb.equal(root.get("username"), username));
        
        Organizer organizer = session.createQuery(query)
                            .setMaxResults(1)
                            .uniqueResult();
        
        return Optional.ofNullable(organizer);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Organizer> findAll() {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Organizer> query = cb.createQuery(Organizer.class);
        Root<Organizer> root = query.from(Organizer.class);
        
        query.select(root);
        
        return session.createQuery(query).getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Organizer> searchByKeyword(String keyword) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Organizer> query = cb.createQuery(Organizer.class);
        Root<Organizer> root = query.from(Organizer.class);
        
        String likePattern = "%" + keyword.toLowerCase() + "%";
        
        query.select(root)
             .where(
                 cb.or(
                     cb.like(cb.lower(root.get("fullName")), likePattern),
                     cb.like(cb.lower(root.get("username")), likePattern)
                 )
             );
        
        return session.createQuery(query).getResultList();
    }

    @Override
    public void deleteById(Long id) {       
        Organizer organizer = getById(Organizer.class, id);
        if (organizer != null) {
            deleteEntity(organizer);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsByUsername(String username) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Long> query = cb.createQuery(Long.class);
        Root<Organizer> root = query.from(Organizer.class);
        
        query.select(cb.count(root)).where(cb.equal(root.get("username"), username));
        
        Long count = session.createQuery(query).getSingleResult();
        
        return count > 0;
    }
    
    @Override
    @Transactional(readOnly = true)
    public boolean hasEvents(Long id) {
        Session session = getSession();
        
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Long> query = cb.createQuery(Long.class);
        Root<Event> root = query.from(Event.class);
        
        Organizer organizer = this.findById(id).get();
        
        query.select(cb.count(root)).where(cb.equal(root.get("organizer"), organizer));
        
        Long count = session.createQuery(query).getSingleResult();
        
        return count > 0;
    }
}