class Test
{
  //inputs
  int testID;
  String name;
  IntList promptList;

  int lightPosition;
  int numLights;
  String LED_Color;
  int leftReward; // This is only used for test 1
  int rightReward; // This is only used for test 1
  int wrongResponse;
  int correctResponse; // This is only used for test 2
  
  //this is a list of responses that should elicit a positive output - ie trigger "ding" sound, give reward etc
  StringList correctResponseList;

  //constructor
  Test( TableRow row )
  {
    promptList = new IntList();
    correctResponseList = new StringList();

    testID = row.getInt( "Test ID" );
    
    //name = row.getString( "Animal ID" );
    //numPrompts = row.getInt( "numPrompts" );

    //for ( int i = 0; i < numPrompts; i++ )
    //{
    //  int cell = (2 * i) + 3;
    //  int prompt = row.getInt( cell );

    //  cell += 1;
    //  String response = row.getString(  cell );

    //  promptList.append( prompt );
    //  correctResponseList.append( response );
    //}
    
    //------------ Josh additions
    lightPosition = row.getInt( "LightPosition" );
    numLights = row.getInt( "numLights" );
    LED_Color = row.getString( "Colour" );
    leftReward = row.getInt( "LeftReward" );
    rightReward = row.getInt( "RightReward" );
    wrongResponse = row.getInt( "WrongResponse" );
    correctResponse = row.getInt( "CorrectResponse" );
  }
}