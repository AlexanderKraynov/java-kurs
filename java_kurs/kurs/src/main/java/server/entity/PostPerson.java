package server.entity;

public class PostPerson {
    public Long id;
    public String first_name;
    public String last_name;
    public String pather_name;
    public Integer student_group;
    public Character type;

    public PostPerson(Long id, String first_name, String last_name, String pather_name, Integer student_group, Character type) {
        this.id = id;
        this.first_name = first_name;
        this.last_name = last_name;
        this.pather_name = pather_name;
        this.student_group = student_group;
        this.type = type;
    }
}
