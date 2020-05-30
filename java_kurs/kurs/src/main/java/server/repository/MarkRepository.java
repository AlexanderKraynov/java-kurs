package server.repository;

import org.springframework.data.repository.CrudRepository;
import server.entity.Mark;

public interface MarkRepository extends CrudRepository<Mark, Long> {
}
