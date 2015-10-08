//Simple class for storing responses 

class PromptResponse
{
  int prompt;
  String response;
  int latency;

  //constructor
  PromptResponse(int p, String r, int l)
  {
    prompt = p;
    response = r;
    latency = l;
  }
}

