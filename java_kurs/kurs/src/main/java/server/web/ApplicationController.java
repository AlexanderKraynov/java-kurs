package server.web;

import org.apache.catalina.Group;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import server.entity.*;
import server.exception.MarkNotFoundException;
import server.exception.PersonNotFoundException;
import server.exception.StudentGroupNotFoundException;
import server.exception.SubjectNotFoundException;
import server.service.MarkService;
import server.service.PersonService;
import server.service.StudentGroupService;
import server.service.SubjectService;

import java.util.List;

@RestController
@RequestMapping("/dc")
public class ApplicationController {
    private StudentGroupService studentGroupService;
    private MarkService markService;
    private SubjectService subjectService;
    private PersonService personService;

    @DeleteMapping(value = "mark/{id}")
    public ResponseEntity<Long> deleteMark(@PathVariable Long id) {
        try {
            markService.deleteMark(id);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Mark not found");
        }
        return new ResponseEntity<>(id, HttpStatus.OK);
    }
    @DeleteMapping(value = "people/{id}")
    public ResponseEntity<Long> deletePerson(@PathVariable Long id) {
        try {
            personService.deletePerson(id);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Person not found");
        }
        return new ResponseEntity<>(id, HttpStatus.OK);
    }

    @DeleteMapping(value = "groups/{id}")
    public ResponseEntity<Long> deleteGroup(@PathVariable Long id) {
        try {
            studentGroupService.deleteStudentGroup(id);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Group not found");
        }
        return new ResponseEntity<>(id, HttpStatus.OK);
    }

    @DeleteMapping(value = "subjects/{id}")
    public ResponseEntity<Long> deleteSubject(@PathVariable Long id) {
        try {
            subjectService.deleteSubject(id);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Subject not found");
        }
        return new ResponseEntity<>(id, HttpStatus.OK);
    }

    @PostMapping(value = "/add_mark", consumes = "application/json", produces = "application/json")
    public Mark addMark(@RequestBody PostMark newMark) {
        Person student = personService.findPersonById(newMark.student);
        Person teacher = personService.findPersonById(newMark.teacher);
        if ((student.getType() != 's') || (teacher.getType() != 't')){
            throw new ResponseStatusException(HttpStatus.CONFLICT);
        }
        Subject subject = subjectService.findSubjectById(newMark.subject);
        return markService.addMark(newMark, teacher, student, subject);
    }

    @PostMapping(value = "/add_person", consumes = "application/json", produces = "application/json")
    public Person addPerson(@RequestBody PostPerson newPerson) {
        StudentGroup studentGroup;
        if(newPerson.student_group != null)
            studentGroup = studentGroupService.findStudentGroupById((long)newPerson.student_group);
        else
            studentGroup = null;
        return personService.addPerson(newPerson,studentGroup);
    }

    @PostMapping(value = "/add_group", consumes = "application/json", produces = "application/json")
    public StudentGroup addGroup(@RequestBody StudentGroup newGroup) {
        return studentGroupService.addStudentGroup(newGroup);
    }

    @PostMapping(value = "/add_subject", consumes = "application/json", produces = "application/json")
    public Subject addSubject(@RequestBody Subject newSubject) {
        return subjectService.addSubject(newSubject);
    }

    @GetMapping("/marks")
    public ResponseEntity<List<Mark>> getAllMarks() {
        List<Mark> list = markService.markList();
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @GetMapping("/marks/{id}")
    public ResponseEntity<Mark> getMark(@PathVariable("id") long id) {
        try {
            return new ResponseEntity<>(markService.findMarkById(id),HttpStatus.OK);
        } catch (MarkNotFoundException exception) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Mark not found");
        }
    }

    @GetMapping("/groups")
    public ResponseEntity<List<StudentGroup>> getAllGroups() {
        List<StudentGroup> list = studentGroupService.studentGroupList();
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @GetMapping("/groups/{id}")
    public ResponseEntity<StudentGroup> getGroup(@PathVariable("id") long id) {
        try {
            return new ResponseEntity<>(studentGroupService.findStudentGroupById(id),HttpStatus.OK);
        } catch (StudentGroupNotFoundException exception) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Group not found");
        }
    }

    @GetMapping("/people")
    public ResponseEntity<List<Person>> getAllPeople() {
        List<Person> list = personService.personServiceList();
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @GetMapping("/people/{id}")
    public ResponseEntity<Person> getPerson(@PathVariable("id") long id) {
        try {
            return new ResponseEntity<>(personService.findPersonById(id),HttpStatus.OK);
        } catch (PersonNotFoundException exception) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Person not found");
        }
    }

    @GetMapping("/subjects")
    public ResponseEntity<List<Subject>> getAllSubject() {
        List<Subject> list = subjectService.listSubject();
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @GetMapping("/subjects/{id}")
    public ResponseEntity<Subject> getSubject(@PathVariable("id") long id) {
        try {
            return new ResponseEntity<>(subjectService.findSubjectById(id),HttpStatus.OK);
        } catch (SubjectNotFoundException exception) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Subject not found");
        }
    }

    @Autowired
    public void setGroupService(StudentGroupService studentGroupService) {
        this.studentGroupService = studentGroupService;
    }
    @Autowired
    public void setMarkService(MarkService markService) {
        this.markService = markService;
    }
    @Autowired
    public void setSubjectService(SubjectService subjectService) {
        this.subjectService = subjectService;
    }
    @Autowired
    public void setPersonService(PersonService personService) {
        this.personService = personService;
    }
}
