package server.service;

import server.entity.Person;
import server.entity.PostPerson;
import server.entity.StudentGroup;

import java.util.List;

public interface PersonService {
    List<Person> personServiceList();
    Person findPersonById(long id);
    Person addPerson(PostPerson person, StudentGroup studentGroup);
    void deletePerson(long id);
}
