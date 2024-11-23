<?php
include 'db.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Information</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>User Admission Form</h1>

        <!-- Display Success/Error Message -->
        <?php if (isset($_GET['success'])): ?>
            <div class="alert success">Form submitted successfully!</div>
        <?php elseif (isset($_GET['error'])): ?>
            <div class="alert error">Failed to submit the form.</div>
        <?php endif; ?>

        <!-- Admission Form -->
        <form action="process.php" method="POST" enctype="multipart/form-data">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>

            <label for="roll_no">Roll No:</label>
            <input type="text" id="roll_no" name="roll_no" required>

            <label for="class">Class:</label>
            <input type="text" id="class" name="class" required>

            <label for="course">Course:</label>
            <input type="text" id="course" name="course" required>

            <label for="session">Session:</label>
            <input type="text" id="session" name="session" required>

            <label for="image">Upload Image:</label>
            <input type="file" id="image" name="image" accept="image/*" required>

            <button type="submit">Submit</button>
        </form>

        <!-- Data Table -->
        <h2>All Users</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Roll No</th>
                    <th>Class</th>
                    <th>Course</th>
                    <th>Session</th>
                    <th>Image</th>
                    <th>Created At</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $result = $conn->query("SELECT * FROM users ORDER BY created_at DESC");
                if ($result->num_rows > 0) {
                    while ($row = $result->fetch_assoc()) {
                        echo "<tr>
                                <td>{$row['id']}</td>
                                <td>{$row['name']}</td>
                                <td>{$row['roll_no']}</td>
                                <td>{$row['class']}</td>
                                <td>{$row['course']}</td>
                                <td>{$row['session']}</td>
                                <td><img src='{$row['image_path']}' alt='Image' width='50'></td>
                                <td>{$row['created_at']}</td>
                              </tr>";
                    }
                } else {
                    echo "<tr><td colspan='8'>No records found.</td></tr>";
                }
                ?>
            </tbody>
        </table>
    </div>
</body>
</html>
