<?php 
include_once 'config.php';
include_once 'mysql.php';
include_once 'string.php';
$link=connect();

// do function
$name = 'zhangsan';
$name2= 'wangsi';
$name3='liqi';
$passw = '1234567';
$code = '12398';

$q1 = "select is_user('$name','$passw')";
$q2 = "select is_number('$passw')";
$q3 = "select get_pid('$name2')";


$result=execute($link, $q3);



while ($row=$result->fetch_array()) {   
    echo $row[0];
    
}
// function ends

echo "<hr>";


// do procedure

// ## NO1##
$code = '11234';
$sql = "call show_home_course('$code');"; 
// ## NO1##

// ## NO2##
$u_name='wangsi';
$d_date='2019-10-08 00:00:00';
$d_date2='2019-10-20 00:00:00';

$text='Go to school in 15 minutes';
$sql2 ="call Insert_daily('$u_name','$d_date','$text');"; 
// ## NO2##

// ## NO3##
$u_name='wangsi';
$sql3 = "call show_chosen_code('$u_name');";
// ## NO3##


//## NO4 ##
$str = '434,1,123,567';
$del = ',';
$sql4 = "call splitString('$str','$del');"; 
// ## NO4##


// ## NO5##
$name='liqi';
$code = '12398';
$sql5 = "call get_course_info('$name','$code')";
// ## NO5##

$result=execute_q($link,$sql5);


//## output result ##
var_dump($result);
//select多少列，就使用echo row[i] 多少次
while ($row=$result->fetch_array()) {   
    echo $row[0];
    echo "<hr>";
//   echo $row[1];
  //  echo "<hr>";
//   echo $row[2];
  //  echo "<hr>";
//   echo $row[3];
  //  echo "<hr>";
   
}
//## output result##

// procedure ends



close($link);
?>