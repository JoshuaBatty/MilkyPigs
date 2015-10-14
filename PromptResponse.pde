//Simple class for storing responses 

class PromptResponse
{
  int prompt;
  int latency;
  String response;

  //constructor
  PromptResponse(int p, String r, int l)
  {
    prompt = p;
    response = r;
    latency = l;
  }
}