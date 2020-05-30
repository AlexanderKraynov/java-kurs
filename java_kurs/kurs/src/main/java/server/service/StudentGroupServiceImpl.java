package server.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import server.entity.StudentGroup;
import server.exception.StudentGroupNotFoundException;
import server.repository.StudentGroupRepository;

import java.util.List;
import java.util.Optional;

@Service
public class StudentGroupServiceImpl implements  StudentGroupService{

    @Autowired
    private StudentGroupRepository groupRepository;
    @Override
    public List<StudentGroup> studentGroupList() {
        return (List<StudentGroup>) groupRepository.findAll();
    }

    @Override
    public StudentGroup findStudentGroupById(long id) {
        Optional<StudentGroup> optionalGroup = groupRepository.findById(id);
        if(optionalGroup.isPresent()) {
            return optionalGroup.get();
        } else {
            throw new StudentGroupNotFoundException("Group not found");
        }
    }

    @Override
    public StudentGroup addStudentGroup(StudentGroup studentGroup) {
        return groupRepository.save(studentGroup);
    }

    @Override
    public void deleteStudentGroup(long id) {
        groupRepository.deleteById(id);
    }
}
