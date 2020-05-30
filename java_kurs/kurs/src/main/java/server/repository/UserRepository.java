package server.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import server.entity.DbUser;

import java.util.Optional;

public interface UserRepository extends JpaRepository<DbUser, Long> {
    Optional<DbUser> findUsersByUserName(String userName);
}
