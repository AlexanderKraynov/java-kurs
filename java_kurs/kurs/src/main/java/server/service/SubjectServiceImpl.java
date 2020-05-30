package server.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import server.entity.Subject;
import server.exception.SubjectNotFoundException;
import server.repository.SubjectRepository;

import java.util.List;
import java.util.Optional;

@Service
public class SubjectServiceImpl implements SubjectService{

    @Autowired
    private SubjectRepository subjectRepository;
    @Override
    public List<Subject> listSubject() {
        return (List<Subject>) subjectRepository.findAll();
    }

    @Override
    public Subject findSubjectById(long id) {
        Optional<Subject> optionalSubject = subjectRepository.findById(id);
        if(optionalSubject.isPresent()) {
            return optionalSubject.get();
        } else {
            throw new SubjectNotFoundException("Subject not found");
        }
    }

    @Override
    public Subject addSubject(Subject subject) {
        return subjectRepository.save(subject);
    }

    @Override
    public void deleteSubject(long id) {
        subjectRepository.deleteById(id);
    }
}
