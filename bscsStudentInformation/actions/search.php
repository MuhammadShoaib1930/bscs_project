<?php
include('../db_config.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Collect search criteria from POST data
    $roll_no = isset($_POST['roll_no']) ? $_POST['roll_no'] : '';
    $name = isset($_POST['name']) ? $_POST['name'] : '';

    // Build the SQL query dynamically based on provided inputs
    $conditions = [];
    if (!empty($roll_no)) {
        $conditions[] = "roll_no = '$roll_no'";
    }
    if (!empty($name)) {
        $conditions[] = "name LIKE '%$name%'";
    }

    // Start the query with the basic SELECT
    $sql = "SELECT * FROM student";
    if (count($conditions) > 0) {
        $sql .= " WHERE " . implode(' AND ', $conditions);
    }

    $result = $conn->query($sql);

    // Check if any results were returned
    if ($result->num_rows > 0) {
        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode($data);
    } else {
        echo "No records found!";
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
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fa;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form-container {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 600px;
            text-align: center;
        }
        .form-container h2 {
            margin-bottom: 20px;
            color: #333;
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 8px;
            display: block;
            color: #333;
        }
        .form-group input {
            width: 90%;
            padding: 12px;
            font-size: 16px;
            border: 2px solid #ccc;
            border-radius: 8px;
            outline: none;
        }
        .form-group input:focus {
            border-color: #007bff;
        }
        .form-group button {
            width: 90%;
            padding: 12px;
            font-size: 18px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .form-group button:hover {
            background-color: #0056b3;
        }
        .results {
            margin-top: 30px;
            width: 100%;
        }
        .results table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 16px;
        }
        .results th, .results td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }
        .results th {
            background-color: #007bff;
            color: #fff;
        }
        .error-message {
            color: red;
            font-weight: bold;
            font-size: 18px;
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Search Student Records</h2>
        <form method="POST" action="" id="searchForm">
            <div class="form-group">
                <label for="roll_no">Roll Number (Optional):</label>
                <input type="text" id="roll_no" name="roll_no" placeholder="Enter Roll Number">
            </div>
            <div class="form-group">
                <label for="name">Name (Optional):</label>
                <input type="text" id="name" name="name" placeholder="Enter Name">
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
            if (data.startsWith('No records found')) {
                resultsDiv.innerHTML = `<p class="error-message">${data}</p>`;
            } else {
                const records = JSON.parse(data);
                if (records.length === 0) {
                    resultsDiv.innerHTML = `<p class="error-message">No matching records found!</p>`;
                } else {
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
            }
        });
    </script>
</body>
</html>
