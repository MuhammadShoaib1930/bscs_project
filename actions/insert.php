<?php
include('../db_config.php');

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $roll_no = $_POST['roll_no'];
    $name = $_POST['name'];
    $father_name = $_POST['father_name'];
    $math = $_POST['math'];
    $physics = $_POST['physics'];
    $english = $_POST['english'];
    $intro_to_computer = $_POST['intro_to_computer'];
    $basic_programming = $_POST['basic_programming'];

    // Insert data into the database
    $sql = "INSERT INTO student (roll_no, name, father_name, math, physics, english, intro_to_computer, basic_programming)
            VALUES ('$roll_no', '$name', '$father_name', $math, $physics, $english, $intro_to_computer, $basic_programming)";

    if ($conn->query($sql) === TRUE) {
        $message = "New record created successfully!";
    } else {
        $message = "Error: " . $sql . "<br>" . $conn->error;
    }
    $conn->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insert Student Record</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form-container {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 400px;
        }
        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #007bff;
        }
        .form-group button {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            background-color: #007bff;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .form-group button:hover {
            background-color: #0056b3;
        }
        .message {
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
        }
        .success {
            color: #28a745;
        }
        .error {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Insert Student Record</h2>
        <?php if (isset($message)): ?>
            <div class="message <?php echo strpos($message, 'successfully') !== false ? 'success' : 'error'; ?>">
                <?php echo $message; ?>
            </div>
        <?php endif; ?>
        <form method="POST" action="">
            <div class="form-group">
                <label for="roll_no">Roll Number:</label>
                <input type="text" id="roll_no" name="roll_no" required>
            </div>
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="father_name">Father's Name:</label>
                <input type="text" id="father_name" name="father_name" required>
            </div>
            <div class="form-group">
                <label for="math">Math:</label>
                <input type="number" id="math" name="math" required>
            </div>
            <div class="form-group">
                <label for="physics">Physics:</label>
                <input type="number" id="physics" name="physics" required>
            </div>
            <div class="form-group">
                <label for="english">English:</label>
                <input type="number" id="english" name="english" required>
            </div>
            <div class="form-group">
                <label for="intro_to_computer">Intro to Computer:</label>
                <input type="number" id="intro_to_computer" name="intro_to_computer" required>
            </div>
            <div class="form-group">
                <label for="basic_programming">Basic Programming:</label>
                <input type="number" id="basic_programming" name="basic_programming" required>
            </div>
            <div class="form-group">
                <button type="submit">Submit</button>
            </div>
        </form>
    </div>
</body>
</html>
