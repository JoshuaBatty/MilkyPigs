class TestResult
{
  //inputs
  String id;
  String name;
  int numPrompts;
  IntList promptList;

  // Which button is pressed? 
  
  // Josh
  String buttonPressed;
  String testDuration;
  
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
    id = test.id;
    name = test.name;
    numPrompts = test.numPrompts;
    promptList = test.promptList;

    started = true;
    complete = false;

    started = true;
    startDate =  day() + "/" + month() + "/" + year();
    startTime = hour() + ":" + minute()+ ":" + second();
    startMillis = millis();

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