List<Map<String,String>> initHaveInHandList () {
  List<Map<String,String>> taskList = [];
  for(var i = 0; i < 8; i++) {
    taskList.add({
      "customer_name" : "Test $i",
      "customer_phone_number" : "+612960765$i$i",
      "time_of_appointment" : "$i/1/2023",
      "start_position" : "location $i",
      "end_position" : "location${i + 1}",
      "cost" : "${i * 10 + 5}",
      "status" : "Watting",
      "whether_to_pay" : "No",
      "task_start_time" : "${i + 19}/1/2023",
      "task_end_time" : "${i + 19}/1/2023"
    });
  }
  return taskList;
}
