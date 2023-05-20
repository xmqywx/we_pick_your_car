
List<Map<String,String>> initTaskList () {
  List<Map<String,String>> taskList = [];
  for(var i = 0; i < 10; i++) {
    taskList.add({
      "customer_name" : "Test $i",
      "customer_phone_number" : "+612960765$i$i",
      "time_of_appointment" : "$i/1/2023",
      "start_position" : "location$i",
      "end_position" : "location${i + 1}",
      "cost" : "${i * 10 + 5}",
      "status" : "Watting",
      "whether_to_pay" : "No",
      "task_start_time" : "2023/1/${i + 2}",
      "task_end_time" : "2023/1/${i + 2}"
    });
  }
  return taskList;
}


// customer_name"
// customer_phone_number
// time_of_appointment
// start_postion
// end_position
// cost
// status
// whether_to_pay
// task_start_time
// task_end_time