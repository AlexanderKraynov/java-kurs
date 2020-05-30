package server.repository;

import org.springframework.data.repository.CrudRepository;
import server.entity.Subject;

public interface SubjectRepository extends CrudRepository<Subject, Long> {
}
