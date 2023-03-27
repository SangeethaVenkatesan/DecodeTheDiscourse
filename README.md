# Decode the Discourse

**Problem Scope**: The issue at hand is the need for active participation and engagement in conversations on LinkedIn, particularly for students who seek to connect with others and foster social interaction. To achieve this, it is important to generate a variety of responses and improve the conversational experience by enhancing context memory, grouping conversations, and analyzing cognitive aspects. With the aid of conversational AI, recommendations for responses can be provided to further enhance engagement. This project aims to create a dashboard using Elixir that aggregates conversation data, identifies key topics discussed, and provides intelligent feedback to individuals seeking to improve their conversational skills. Overall, engaging in conversations on LinkedIn is an effective means of connecting with professionals in one's field.

**Note**: Its not a tool for actively replacing the human conversation input, ultimately I would love to incorporate RLHF (Reinforcement learning with Human Feedback) with Linkedin user who would like to craft the response to include a bit of their persona in the conversations. 

Introducing a tool to enhance conversations on LinkedIn would serve as a helpful reminder for individuals to consider a variety of responses. While there is a risk of losing the personalized touch that many seek on the platform, this tool can be a positive first step towards promoting empathy and social engagement in conversations.


Example conversation:

**Request**: 
```
{
	"history": [
		{
			"user": "Sangeetha",
			"value": "Hello Sudheer, hope you are doing good! I was working on a pipeline for text preprocessing before sending to NLU system to comprehend the message and frame it as question that captures the intent removing not necessary info. I tried to look at how verbosity could be captured,there were resources on finding the independent clause,number of tokens and arrive at a verbosity score. This is just to know when a text needs simplification in the pipeline"
		},
		{
			"user": "Sudheer",
			"value": "Perplexity is not the right measure for verbosity. Perplexity is a measure of uncertainty. Check out readability metrics. There are good readily available packages in Python."
		},
        {
            "user": "Sangeetha",
            "value": "Awesome will check it out noww"
        }
	],
	"message": [
        {
        "user": "Sudheer",
        "value": "Sure, Sangeetha, Sounds great! Hope you are doing great!"
        },
        {
            "user": "Sangeetha",
            "value": ""
        }
    ]
}
```
**History**: History of conversations between the two people. **Message**: This is the message that Sangeetha would like to respond to Sudheer to see the variety of responses, look at summary of conversation.

**Response**:

```
{

"recommendation":"Thanks for the tip, Sudheer! I'll definitely check out the readability metrics. It's always helpful to have a tool to measure verbosity.\n\nBest,\nSangeetha",

"summary":"Sangeetha was working on a pipeline for text preprocessing before sending to NLU system to comprehend the message and frame it as question that captures the intent removing not necessary info. Sudheer recommended readability metrics.",

"summary_cohere":"-Sangeetha is working on a pipeline for text preprocessing.\n
                  - She looked at how verbosity could be captured.\n
                  - Sudheer suggested checking out readability metrics."
                  
}

```

**Featueres till now**:
1) API backend set up with phoenix framework - /api/analyzeconvo
2) Added a recommendation prompt that takes into account history of conversations.
3) Added a separate summary prompt that helps get the summary of conversations before the message.
4) Used cohere summarize endpoint to get the bulleted version of summary of conversations. I would love to extend this to an extent on how it could be leveraged to higher extent when going with long context of messages. 

**Features I would love**:
1) To play with prompts that decodes the cognitive aspects in conversations specifically in Linkedin platform
2) There are so many templates of conversation starter, project request message, collaboration message, appreciation message etc. Would love to see how prompts can be fine tuned on these. 

**Tech Stack**: Elixir (Phoneix Framework), Cohere Large Language Models API


From our Midjourney Friend: Lets Decode the professional conversations and how Large language Models can be a part of it! 

![Screenshot 2023-03-27 at 1 08 18 PM](https://user-images.githubusercontent.com/68361331/228015124-bad7a323-bf6b-41ef-8a87-1c9fc97a37a3.png)




SETUP:

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * Create a dev.secret.exs and add config :linkedin_response, :COHERE_API_KEY, "" - this will help to load the key in the application.


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

