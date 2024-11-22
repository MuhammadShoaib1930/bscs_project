<?php
include('../db_config.php');

// Fetch student records
$sql = "SELECT * FROM student";
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Records</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 95%;
            margin: auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table thead {
            background-color: #007bff;
            color: #fff;
        }
        table th, table td {
            padding: 12px 15px;
            text-align: center;
            border: 1px solid #ddd;
            font-size: 14px;
        }
        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        table tr:hover {
            background-color: #f1f1f1;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        .btn {
            padding: 5px 10px;
            font-size: 12px;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-edit {
            background-color: #28a745;
        }
        .btn-delete {
            background-color: #dc3545;
        }
        .btn-edit:hover {
            background-color: #218838;
        }
        .btn-delete:hover {
            background-color: #c82333;
        }
        .no-records {
            text-align: center;
            font-size: 18px;
            color: #555;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Student Records</h2>
        <?php if ($result->num_rows > 0): ?>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Roll No</th>
                        <th>Name</th>
                        <th>Father Name</th>
                        <th>Math</th>
                        <th>Physics</th>
                        <th>English</th>
                        <th>Intro to Computer</th>
                        <th>Basic Programming</th>
                        <th>Total</th>
                        <th>Percentage</th>
                        <th>Grade</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php $serial = 1; ?>
                    <?php while ($row = $result->fetch_assoc()): ?>
                        <tr>
                            <td><?= $serial++ ?></td>
                            <td><?= htmlspecialchars($row['roll_no']) ?></td>
                            <td><?= htmlspecialchars($row['name']) ?></td>
                            <td><?= htmlspecialchars($row['father_name']) ?></td>
                            <td><?= htmlspecialchars($row['math']) ?></td>
                            <td><?= htmlspecialchars($row['physics']) ?></td>
                            <td><?= htmlspecialchars($row['english']) ?></td>
                            <td><?= htmlspecialchars($row['intro_to_computer']) ?></td>
                            <td><?= htmlspecialchars($row['basic_programming']) ?></td>
                            <td><?= htmlspecialchars($row['total_marks']) ?></td>
                            <td><?= htmlspecialchars($row['percentage']) ?>%</td>
                            <td><?= htmlspecialchars($row['grade']) ?></td>
                            <td class="action-buttons">
                                <button class="btn btn-edit" onclick="window.location.href='update.php?roll_no=<?= $row['roll_no'] ?>'">Edit</button>
                                <button class="btn btn-delete" onclick="confirmDelete('<?= $row['roll_no'] ?>')">Delete</button>
                            </td>
                        </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        <?php else: ?>
            <div class="no-records">No records found!</div>
        <?php endif; ?>
    </div>

    <script>
        function confirmDelete(rollNo) {
            if (confirm("Are you sure you want to delete this record?")) {
                window.location.href = 'delete.php?roll_no=' + rollNo;
            }
        }
    </script>
</body>
</html>

<?php
$conn->close();
?>
