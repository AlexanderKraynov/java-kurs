package server.entity;

import javax.persistence.*;

@Entity
public class Person {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long id;

    @Column(name = "first_name", nullable = false)
    private String first_name;
    @Column(name = "last_name", nullable = false)
    private String last_name;
    @Column(name = "pather_name", nullable = false)
    private String pather_name;
    @ManyToOne
    @JoinColumn(name = "group_id", referencedColumnName = "id")
    private StudentGroup student_group;

    @Column(name = "type", nullable = false)
    private Character type;

    public Person() {
    }
    public Person(Long id, String first_name, String last_name, String pather_name, StudentGroup studentGroup, Character type) {
        this.id = id;
        this.first_name = first_name;
        this.last_name = last_name;
        this.pather_name = pather_name;
        this.student_group = studentGroup;
        this.type = type;
    }
    public Person(PostPerson postPerson) {
        this.id = postPerson.id;
        this.first_name = postPerson.first_name;
        this.last_name = postPerson.last_name;
        this.pather_name = postPerson.pather_name;
        this.type = postPerson.type;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirst_name() {
        return first_name;
    }

    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }

    public String getLast_name() {
        return last_name;
    }

    public void setLast_name(String last_name) {
        this.last_name = last_name;
    }

    public String getPather_name() {
        return pather_name;
    }

    public void setPather_name(String pather_name) {
        this.pather_name = pather_name;
    }

    public StudentGroup getStudent_group() {
        return student_group;
    }

    public void setStudent_group(StudentGroup studentGroup) {
        this.student_group = studentGroup;
    }

    public Character getType() {
        return type;
    }

    public void setType(Character type) {
        this.type = type;
    }
}
