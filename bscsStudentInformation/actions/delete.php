<?php
include('../db_config.php');

$deleted_data = null;
$message = "No data deleted.";

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $roll_no = $_POST['roll_no'];

    // Fetch data of the record to delete
    $sql_fetch = "SELECT * FROM student WHERE roll_no = '$roll_no'";
    $result = $conn->query($sql_fetch);

    if ($result->num_rows > 0) {
        $deleted_data = $result->fetch_assoc(); // Store data for displaying later

        // Delete the record
        $sql_delete = "DELETE FROM student WHERE roll_no = '$roll_no'";
        if ($conn->query($sql_delete) === TRUE) {
            $message = "Record deleted successfully!";
        } else {
            $message = "Error deleting record: " . $conn->error;
        }
    } else {
        $message = "No record found with Roll Number: $roll_no";
    }
    $conn->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Student Record</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
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
            border-color: #dc3545;
        }
        .form-group button {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            background-color: #dc3545;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .form-group button:hover {
            background-color: #a71d2a;
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
        .record-details {
            margin-top: 20px;
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
        }
        .record-details table {
            width: 100%;
            border-collapse: collapse;
        }
        .record-details th, .record-details td {
            padding: 8px;
            text-align: left;
            border: 1px solid #ddd;
        }
        .record-details th {
            background-color: #007bff;
            color: #ffffff;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Delete Student Record</h2>
        <?php if ($message): ?>
            <div class="message <?php echo strpos($message, 'successfully') !== false ? 'success' : 'error'; ?>">
                <?php echo $message; ?>
            </div>
        <?php endif; ?>
        <form method="POST" action="">
            <div class="form-group">
                <label for="roll_no">Roll Number (Required to Delete):</label>
                <input type="text" id="roll_no" name="roll_no" required>
            </div>
            <div class="form-group">
                <button type="submit">Delete Record</button>
            </div>
        </form>

        <?php if ($deleted_data): ?>
            <div class="record-details">
                <h3>Deleted Record Details</h3>
                <table>
                    <tr>
                        <th>Field</th>
                        <th>Value</th>
                    </tr>
                    <?php foreach ($deleted_data as $field => $value): ?>
                        <tr>
                            <td><?= htmlspecialchars($field) ?></td>
                            <td><?= htmlspecialchars($value) ?></td>
                        </tr>
                    <?php endforeach; ?>
                </table>
            </div>
        <?php endif; ?>
    </div>
</body>
</html>
