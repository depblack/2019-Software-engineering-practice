<?php 
include_once 'config.php';
include_once 'mysql.php';
$link=connect();

// do function
$name = 'zhangsan';
$passw = '1234567';

$q = "select is_user('$name','$passw')";
$sql = "select is_number('$passw')";


$result=execute($link, $q);



while ($row=$result->fetch_array()) {   
    echo $row[0];
    
}
// function ends

echo "<hr>";


// do procedure
$code = '11234';

$sql = "call show_home_course('$code');"; 

$result=execute_q($link,$sql);

while ($row=$result->fetch_array()) {   
    echo $row[0];
    echo "<hr>";
    echo $row[1];
    echo "<hr>";
    echo $row[2];
    echo "<hr>";
    echo $row[3];
    echo "<hr>";
}


// procedure ends


#$result=execute($link, $sql);


/*
while(!!$row = mysqli_fetch_assoc($result)){
        echo"<tr><td>".$row["user_id"]."</td><td>".$row["user_name"]."</td><td>".$row["user_password"]."</td><td>".$row["user_pid"]."</td><tr>";
    echo"<tr><td>";
    echo $row['user_id'];
    echo"<tr><td>";
    echo $row['user_name'];
    echo $row['user_password'];
   
    }
*/







close($link);
?>