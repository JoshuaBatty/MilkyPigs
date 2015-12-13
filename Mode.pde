//The Mode class is the base class for each test phase.
//They're really states.  Renaming might be good.
//Each mode will have some way of switching another mode,  usually by keypress or click

abstract class Mode
{
  abstract void setup();
  abstract void draw();
  abstract void mousePressed();
  abstract void keyPressed();

  //When a test is aborted 
  void abortTest()
  {
    println( "Test aborted" );
    currentTestResult.abort();
    resultList.add( currentTestResult );
    println( "number of results = " + resultList.size() );
    currentTestIndex = 0;

    //change state
    //--------------
    mode = SETUP;
  }
}