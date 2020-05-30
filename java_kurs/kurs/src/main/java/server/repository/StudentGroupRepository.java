package server.repository;

import org.springframework.data.repository.CrudRepository;
import server.entity.StudentGroup;

public interface StudentGroupRepository extends CrudRepository<StudentGroup, Long> {
}
