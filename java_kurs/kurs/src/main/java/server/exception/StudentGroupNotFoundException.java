package server.exception;

public class StudentGroupNotFoundException extends RuntimeException {
    public StudentGroupNotFoundException(String message) {
        super(message);
    }
}
