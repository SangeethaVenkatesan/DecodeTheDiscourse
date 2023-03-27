defmodule LinkedinResponseWeb.Controller do
  use LinkedinResponseWeb, :controller
  alias VectorUtils
  use Pipette
  use Retry
  import Stream
  require EEx
  require Logger
  alias Mix.Tasks.Loadpaths
  alias HTTPoison, as: HTTP
  alias Jason, as: JSON
  alias LinkedinResponseWeb.CohereHelper

  EEx.function_from_file(
    :defp,
    :summary_prompt,
    "lib/linkedin_response/prompts/summarize.eex",
    [:history]
  )

  EEx.function_from_file(
    :defp,
    :response_prompt,
    "lib/linkedin_response/prompts/responder.eex",
    [:history, :query]
  )

  def prompt_and_generate(history, response_needed, prompt_type) do
    prompt =
      case prompt_type do
        "summarize" ->
          summary_prompt(history)

        "recommendation" ->
          response_prompt(history, response_needed)
      end

    CohereHelper.generate_response(prompt)
  end

  def send_response(conn, status, response) do
    conn
    |> put_status(status)
    |> json(response)
  end

  def index(conn, params) do
    %{"history" => history, "message" => message} = params

    # # Get the embeddings for the history and response needed
    # # response_needed_embedding = CohereHelper.get_cohere_embedding(message)

    # Generate the summary for the history of conversation
    summary = prompt_and_generate(history, message, "summarize")

    # Generate recommendation for the response needed
    recommendation = prompt_and_generate(history, message, "recommendation")

    # Cohere inbuilt summary generation
    summary_cohere = CohereHelper.generate_summary(history)

    response = %{
      summary: summary,
      recommendation: recommendation,
      summary_cohere: summary_cohere
    }

    send_response(conn, 200, response)
  end
end
