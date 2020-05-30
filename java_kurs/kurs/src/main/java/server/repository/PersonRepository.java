package server.repository;

import org.springframework.data.repository.CrudRepository;
import server.entity.Person;

public interface PersonRepository extends CrudRepository<Person, Long> {
}
