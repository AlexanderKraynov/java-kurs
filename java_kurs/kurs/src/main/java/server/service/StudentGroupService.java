package server.service;

import server.entity.StudentGroup;

import java.util.List;

public interface StudentGroupService {
    List<StudentGroup> studentGroupList();
    StudentGroup findStudentGroupById(long id);
    StudentGroup addStudentGroup(StudentGroup studentGroup);
    void deleteStudentGroup(long id);
}
