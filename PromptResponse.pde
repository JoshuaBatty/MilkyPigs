//Simple class for storing responses 

class PromptResponse
{
  int prompt;
  int testType;
  String reactionTime;
  int lightPosition;
  int numLights;
  int padPressed;
  int numMaltesers;
  int airBlastDuration;
  String colour;
  
      
  //constructor
  PromptResponse(int prompt, int testType, String reactionTime, int lightPosition, int numLights, 
                 int padPressed, int numMaltesers, int airBlastDuration, String colour )
  {
    this.prompt = prompt;
    this.testType = testType;
    this.reactionTime = reactionTime;
    this.lightPosition = lightPosition;
    this.numLights = numLights;
    this.padPressed = padPressed;
    this.numMaltesers = numMaltesers;
    this.airBlastDuration = airBlastDuration;
    this.colour = colour;
  }
}