package server.service;

import server.entity.Subject;

import java.util.List;

public interface SubjectService {
    List<Subject> listSubject();
    Subject findSubjectById(long id);
    Subject addSubject(Subject subject);
    void deleteSubject(long id);
}
