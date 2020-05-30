package server.service;

import server.entity.Mark;
import server.entity.Person;
import server.entity.PostMark;
import server.entity.Subject;

import java.util.List;

public interface MarkService {
    List<Mark> markList();
    Mark findMarkById(long id);
    Mark addMark(PostMark mark, Person teacher, Person student, Subject subject);
    void deleteMark(long id);
}
