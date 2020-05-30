package server;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import server.entity.Person;
import server.entity.StudentGroup;
import server.entity.DbUser;
import server.repository.PersonRepository;
import server.repository.StudentGroupRepository;
import server.repository.UserRepository;

import java.util.Collections;

@Component
public class TestDataInit implements CommandLineRunner {
    @Autowired
    StudentGroupRepository groupRepository;
    @Autowired
    UserRepository userRepository;
    @Autowired
    PersonRepository personRepository;

    @Autowired
    PasswordEncoder pwdEncoder;
    @Override
    public void run(String... args) throws Exception {
//        groupRepository.save(new StudentGroup((long) 2,"3530904/80003"));
//        groupRepository.save(new StudentGroup((long) 3,"3530904/80007"));
//        personRepository.save(new Person((long)15,"Alexander", "Kraynov", "Konstantinovich",groupRepository.findById((long)1).get(),'s'));
//        personRepository.save(new Person((long)14,"Ilya", "Shemyakin", "Alexandrovich",null,'t'));
//        userRepository.save(new DbUser("user", pwdEncoder.encode("password"), Collections.singletonList("ROLE_USER")));
//        userRepository.save(new DbUser("admin", pwdEncoder.encode("admin"), Collections.singletonList("ROLE_ADMIN")));
    }
}
