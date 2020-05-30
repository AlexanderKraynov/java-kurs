package server.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import server.entity.Person;
import server.entity.PostPerson;
import server.entity.StudentGroup;
import server.exception.PersonNotFoundException;
import server.repository.PersonRepository;

import java.util.List;
import java.util.Optional;

@Service
public class PersonServiceImpl implements PersonService{
    @Autowired
    private PersonRepository personRepository;

    @Override
    public List<Person> personServiceList() {
        return (List<Person>) personRepository.findAll();
    }

    @Override
    public Person findPersonById(long id) {
        Optional<Person> optionalPerson = personRepository.findById(id);
        if(optionalPerson.isPresent()) {
            return optionalPerson.get();
        } else {
            throw new PersonNotFoundException("Person not found");
        }
    }

    @Override
    public Person addPerson(PostPerson person, StudentGroup studentGroup) {
        Person personToSave = new Person(person);
        personToSave.setStudent_group(studentGroup);
        return personRepository.save(personToSave);
    }

    @Override
    public void deletePerson(long id) {
        personRepository.deleteById(id);
    }
}
