<?php
include('../db_config.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Collect search criteria from POST data
    $roll_no = isset($_POST['roll_no']) ? $_POST['roll_no'] : '';
    $name = isset($_POST['name']) ? $_POST['name'] : '';
    $father_name = isset($_POST['father_name']) ? $_POST['father_name'] : '';

    // Build the SQL query dynamically based on provided inputs
    $conditions = [];
    if (!empty($roll_no)) {
        $conditions[] = "roll_no = '$roll_no'";
    }
    if (!empty($name)) {
        $conditions[] = "name LIKE '%$name%'";
    }
    if (!empty($father_name)) {
        $conditions[] = "father_name LIKE '%$father_name%'";
    }

    $sql = "SELECT * FROM student";
    if (count($conditions) > 0) {
        $sql .= " WHERE " . implode(' AND ', $conditions);
    }

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode($data);
    } else {
        echo "No record found!";
    }
    $conn->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Student Records</title>
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
            width: 500px;
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
        .results {
            margin-top: 20px;
        }
        .results table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .results th, .results td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .results th {
            background-color: #007bff;
            color: #ffffff;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Search Student Records</h2>
        <form method="POST" action="" id="searchForm">
            <div class="form-group">
                <label for="roll_no">Roll Number:</label>
                <input type="text" id="roll_no" name="roll_no" placeholder="Enter Roll Number">
            </div>
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" placeholder="Enter Name">
            </div>
            <div class="form-group">
                <label for="father_name">Father's Name:</label>
                <input type="text" id="father_name" name="father_name" placeholder="Enter Father's Name">
            </div>
            <div class="form-group">
                <button type="submit">Search</button>
            </div>
        </form>
        <div class="results" id="results"></div>
    </div>

    <script>
        const form = document.getElementById('searchForm');
        const resultsDiv = document.getElementById('results');

        form.addEventListener('submit', async (event) => {
            event.preventDefault();

            const formData = new FormData(form);
            const response = await fetch('', {
                method: 'POST',
                body: formData,
            });

            const data = await response.text();
            if (data.startsWith('No record found')) {
                resultsDiv.innerHTML = `<p style="color: red;">${data}</p>`;
            } else {
                const records = JSON.parse(data);
                let table = `<table>
                    <thead>
                        <tr>
                            <th>Roll No</th>
                            <th>Name</th>
                            <th>Father's Name</th>
                            <th>Math</th>
                            <th>Physics</th>
                            <th>English</th>
                            <th>Intro to Computer</th>
                            <th>Basic Programming</th>
                        </tr>
                    </thead>
                    <tbody>`;
                records.forEach(record => {
                    table += `<tr>
                        <td>${record.roll_no}</td>
                        <td>${record.name}</td>
                        <td>${record.father_name}</td>
                        <td>${record.math}</td>
                        <td>${record.physics}</td>
                        <td>${record.english}</td>
                        <td>${record.intro_to_computer}</td>
                        <td>${record.basic_programming}</td>
                    </tr>`;
                });
                table += `</tbody></table>`;
                resultsDiv.innerHTML = table;
            }
        });
    </script>
</body>
</html>
