package server.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import server.entity.Mark;
import server.entity.Person;
import server.entity.PostMark;
import server.entity.Subject;
import server.exception.MarkNotFoundException;
import server.repository.MarkRepository;

import java.util.List;
import java.util.Optional;

@Service
public class MarkServiceImpl implements MarkService{
    @Autowired
    private MarkRepository markRepository;
    @Override
    public List<Mark> markList() {
        return (List<Mark>) markRepository.findAll();
    }

    @Override
    public Mark findMarkById(long id) {
        Optional<Mark> optionalMark = markRepository.findById(id);
        if(optionalMark.isPresent()) {
            return optionalMark.get();
        } else {
            throw new MarkNotFoundException("Mark not found");
        }
    }

    @Override
    public Mark addMark(PostMark mark, Person teacher, Person student, Subject subject) {
        Mark markToSave = new Mark(mark);
        markToSave.setTeacher(teacher);
        markToSave.setStudent(student);
        markToSave.setSubject(subject);
        return markRepository.save(markToSave);
    }

    @Override
    public void deleteMark(long id) {
        markRepository.deleteById(id);
    }
}
