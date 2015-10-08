class Test
{
  //inputs
  String id;
  String name;
  int numPrompts;
  IntList promptList;

  //this is a list of responses that should elicit a positive output - ie trigger "ding" sound, give reward etc
  StringList correctResponseList;

  //constructor
  Test( TableRow row )
  {
    promptList = new IntList();
    correctResponseList = new StringList();

    id = row.getString( "Test ID" );
    name = row.getString( "Animal ID" );
    numPrompts = row.getInt( "numPrompts" );

    for ( int i = 0; i < numPrompts; i++ )
    {
      int cell = (2 * i) + 3;
      int prompt = row.getInt( cell );

      cell += 1;
      String response = row.getString(  cell );

      promptList.append( prompt );
      correctResponseList.append( response );
    }
  }
}

