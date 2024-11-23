<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = htmlspecialchars($_POST['name']);
    $roll_no = htmlspecialchars($_POST['roll_no']);
    $class = htmlspecialchars($_POST['class']);
    $course = htmlspecialchars($_POST['course']);
    $session = htmlspecialchars($_POST['session']);
    $image_path = '';

    // Handle image upload
    if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
        $uploadDir = 'uploads/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }
        $image_path = $uploadDir . time() . '_' . basename($_FILES['image']['name']);
        if (!move_uploaded_file($_FILES['image']['tmp_name'], $image_path)) {
            die("Failed to upload image.");
        }
    }

    // Insert data into the database
    $stmt = $conn->prepare("INSERT INTO users (name, roll_no, class, course, session, image_path) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssss", $name, $roll_no, $class, $course, $session, $image_path);

    if ($stmt->execute()) {
        header("Location: index.php?success=1");
    } else {
        header("Location: index.php?error=1");
    }

    $stmt->close();
}
?>
