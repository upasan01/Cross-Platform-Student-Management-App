import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;

/**
 * Student Management Application (Console-based, Cross-Platform Java)
 * This application provides CRUD (Create, Read, Update, Delete) operations for student records.
 * It is designed to be self-contained and runnable on any platform with a JVM.
 */

// --- MODEL: Represents the data structure ---
class Student {
    private String studentId;
    private String name;
    private int age;
    private String course;

    public Student(String studentId, String name, int age, String course) {
        this.studentId = studentId;
        this.name = name;
        this.age = age;
        this.course = course;
    }

    // Getters
    public String getStudentId() { return studentId; }
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getCourse() { return course; }

    // Setters (for updating)
    public void setName(String name) { this.name = name; }
    public void setAge(int age) { this.age = age; }
    public void setCourse(String course) { this.course = course; }

    @Override
    public String toString() {
        return String.format("| ID: %-5s | Name: %-20s | Age: %-3d | Course: %-15s |",
                studentId, name, age, course);
    }
}

// --- CONTROLLER: Manages the business logic and data persistence (in-memory) ---
class StudentManager {
    private final List<Student> students;

    public StudentManager() {
        this.students = new ArrayList<>();
    }

    /**
     * Adds a new student record.
     * @return true if the student was added, false if ID already exists.
     */
    public boolean addStudent(Student student) {
        // Prevent duplicate IDs
        if (students.stream().anyMatch(s -> s.getStudentId().equals(student.getStudentId()))) {
            return false;
        }
        students.add(student);
        return true;
    }

    /**
     * Retrieves all student records.
     */
    public List<Student> getAllStudents() {
        return students;
    }

    /**
     * Searches for a student by ID.
     */
    public Student getStudentById(String id) {
        return students.stream()
                .filter(s -> s.getStudentId().equalsIgnoreCase(id))
                .findFirst()
                .orElse(null);
    }

    /**
     * Updates an existing student's details.
     * @return true if the student was found and updated, false otherwise.
     */
    public boolean updateStudent(String id, String newName, int newAge, String newCourse) {
        Student student = getStudentById(id);
        if (student != null) {
            student.setName(newName);
            student.setAge(newAge);
            student.setCourse(newCourse);
            return true;
        }
        return false;
    }

    /**
     * Deletes a student record by ID.
     * @return true if the student was found and removed, false otherwise.
     */
    public boolean deleteStudent(String id) {
        return students.removeIf(s -> s.getStudentId().equalsIgnoreCase(id));
    }

    /**
     * Searches for students by name (case-insensitive partial match).
     */
    public List<Student> searchStudentsByName(String nameQuery) {
        return students.stream()
                .filter(s -> s.getName().toLowerCase().contains(nameQuery.toLowerCase()))
                .collect(Collectors.toList());
    }
}

// --- VIEW/MAIN APP: Handles user interaction and application flow ---
public class StudentManagementApp {
    private final StudentManager manager;
    private final Scanner scanner;

    public StudentManagementApp() {
        this.manager = new StudentManager();
        this.scanner = new Scanner(System.in);
        // Add some dummy data for quick testing
        manager.addStudent(new Student("S1001", "Alice Johnson", 20, "Computer Science"));
        manager.addStudent(new Student("S1002", "Bob Smith", 22, "Mechanical Engineering"));
        manager.addStudent(new Student("S1003", "Charlie Brown", 19, "Liberal Arts"));
    }

    /**
     * Displays the main menu options.
     */
    private void displayMenu() {
        System.out.println("\n=======================================================");
        System.out.println("  Cross-Platform Student Management Console App");
        System.out.println("=======================================================");
        System.out.println("1. Add New Student");
        System.out.println("2. View All Students");
        System.out.println("3. Search Student by Name");
        System.out.println("4. Update Student Details");
        System.out.println("5. Delete Student by ID");
        System.out.println("6. Exit");
        System.out.println("-------------------------------------------------------");
        System.out.print("Enter your choice: ");
    }

    /**
     * Runs the main application loop.
     */
    public void run() {
        boolean running = true;
        while (running) {
            displayMenu();
            if (scanner.hasNextInt()) {
                int choice = scanner.nextInt();
                scanner.nextLine(); // Consume newline
                try {
                    switch (choice) {
                        case 1: addStudent(); break;
                        case 2: viewAllStudents(); break;
                        case 3: searchStudentByName(); break;
                        case 4: updateStudent(); break;
                        case 5: deleteStudent(); break;
                        case 6:
                            running = false;
                            System.out.println("Thank you for using the Student Management App. Goodbye!");
                            break;
                        default:
                            System.out.println("Invalid choice. Please enter a number between 1 and 6.");
                    }
                } catch (Exception e) {
                    System.err.println("An unexpected error occurred: " + e.getMessage());
                }
            } else {
                System.out.println("Invalid input. Please enter a number.");
                scanner.nextLine(); // Consume invalid input
            }
        }
    }

    private void addStudent() {
        System.out.println("\n--- Add New Student ---");
        System.out.print("Enter Student ID (e.g., S1004): ");
        String id = scanner.nextLine().trim();

        if (manager.getStudentById(id) != null) {
            System.out.println("Error: Student with ID " + id + " already exists.");
            return;
        }

        System.out.print("Enter Name: ");
        String name = scanner.nextLine().trim();

        int age = -1;
        while (age < 0) {
            System.out.print("Enter Age: ");
            if (scanner.hasNextInt()) {
                age = scanner.nextInt();
            } else {
                System.out.println("Invalid age input. Please enter a number.");
            }
            scanner.nextLine(); // Consume newline or invalid input
        }

        System.out.print("Enter Course: ");
        String course = scanner.nextLine().trim();

        Student newStudent = new Student(id, name, age, course);
        if (manager.addStudent(newStudent)) {
            System.out.println("Success: Student " + name + " added successfully.");
        }
    }

    private void viewAllStudents() {
        List<Student> all = manager.getAllStudents();
        System.out.println("\n--- All Students (" + all.size() + " Records) ---");
        if (all.isEmpty()) {
            System.out.println("No student records found.");
            return;
        }
        System.out.println("-----------------------------------------------------------------------------------");
        System.out.printf("| ID    | Name                 | Age | Course            |\n");
        System.out.println("-----------------------------------------------------------------------------------");
        for (Student s : all) {
            System.out.println(s);
        }
        System.out.println("-----------------------------------------------------------------------------------");
    }

    private void searchStudentByName() {
        System.out.println("\n--- Search Student by Name ---");
        System.out.print("Enter name or partial name to search: ");
        String query = scanner.nextLine().trim();

        List<Student> results = manager.searchStudentsByName(query);
        if (results.isEmpty()) {
            System.out.println("No students found matching '" + query + "'.");
            return;
        }

        System.out.println("--- Search Results (" + results.size() + " Records) ---");
        System.out.println("-----------------------------------------------------------------------------------");
        for (Student s : results) {
            System.out.println(s);
        }
        System.out.println("-----------------------------------------------------------------------------------");
    }

    private void updateStudent() {
        System.out.println("\n--- Update Student Details ---");
        System.out.print("Enter Student ID to update: ");
        String id = scanner.nextLine().trim();

        Student student = manager.getStudentById(id);
        if (student == null) {
            System.out.println("Error: Student with ID " + id + " not found.");
            return;
        }

        System.out.println("Current details: " + student);
        System.out.println("--- Enter New Details (Leave blank to keep current value) ---");

        System.out.print("New Name (" + student.getName() + "): ");
        String newName = scanner.nextLine().trim();
        if (!newName.isEmpty()) student.setName(newName);

        int newAge = student.getAge();
        System.out.print("New Age (" + student.getAge() + "): ");
        String ageInput = scanner.nextLine().trim();
        if (!ageInput.isEmpty()) {
            try {
                newAge = Integer.parseInt(ageInput);
                if (newAge < 0) throw new NumberFormatException();
                student.setAge(newAge);
            } catch (NumberFormatException e) {
                System.out.println("Invalid age input. Age remains " + student.getAge() + ".");
            }
        }

        System.out.print("New Course (" + student.getCourse() + "): ");
        String newCourse = scanner.nextLine().trim();
        if (!newCourse.isEmpty()) student.setCourse(newCourse);

        System.out.println("Success: Student " + id + " updated.");
        System.out.println("New details: " + student);
    }

    private void deleteStudent() {
        System.out.println("\n--- Delete Student by ID ---");
        System.out.print("Enter Student ID to delete: ");
        String id = scanner.nextLine().trim();

        if (manager.deleteStudent(id)) {
            System.out.println("Success: Student with ID " + id + " has been removed.");
        } else {
            System.out.println("Error: Student with ID " + id + " not found.");
        }
    }

    public static void main(String[] args) {
        StudentManagementApp app = new StudentManagementApp();
        app.run();
    }
}
