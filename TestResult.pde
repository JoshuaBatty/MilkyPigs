class TestResult
{
  //inputs
  int testID;
  String name;
  IntList promptList;
  
  
  // Which button is pressed? 
  
  //results
  String startDate;
  String startTime;
  String endTime;
  int startMillis;
  int endMillis;
  int totalMillis;
  ArrayList<PromptResponse> responseList;

  boolean started;
  boolean complete;

  //constructor
  TestResult( Test test )
  {
    testID = test.testID;
    name = test.name;
    promptList = test.promptList;

    started = true;
    complete = false;

    started = true;
    startDate =  day() + "/" + month() + "/" + year();
    startMillis = millis();
    startTime = hour() + ":" + minute()+ ":" + second();
    responseList = new ArrayList<PromptResponse>();
  }

  void end()
  {
    complete = true;
    endTime = hour() + ":" + minute()+ ":" + second();
    endMillis = millis();
    totalMillis = endMillis - startMillis;
  }

  void abort()
  {
    complete = true;
    endTime = hour() + ":" + minute()+ ":" + second() + " (ABORTED)";
    endMillis = millis();
    totalMillis = endMillis - startMillis;
  }
}