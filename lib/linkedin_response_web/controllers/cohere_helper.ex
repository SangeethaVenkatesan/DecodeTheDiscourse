defmodule LinkedinResponseWeb.CohereHelper do
  alias HTTPoison, as: HTTP
  alias Jason, as: JSON
  require Logger

  def headers() do
    cohere_api_key = Application.fetch_env!(:linkedin_response, :COHERE_API_KEY)

    [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{cohere_api_key}"}
    ]
  end

  defp query_embeddings(query) do
    HTTP.post(
      "https://api.cohere.ai/v1/embed",
      JSON.encode!(%{"texts" => [query], truncate: "END"}),
      headers()
    )
  end

  defp generate_endpoint(prompt) do
    HTTP.post(
      "https://api.cohere.ai/v1/generate",
      JSON.encode!(%{
        "prompt" => prompt,
        "max_tokens" => 100,
        "model" => "command-xlarge-nightly",
        "temperature" => 0.7
      }),
      headers()
    )
  end

  defp generate_summary_endpoint(prompt) do
    HTTP.post(
      "https://api.cohere.ai/v1/summarize",
      JSON.encode!(%{
        "text" => prompt,
        "length" => "medium",
        "model" => "summarize-xlarge",
        "temperature" => 0.7,
        "format" => "bullets",
        "additional_command" =>
          "Focus that its a professional conversation summary in Linkedin network"
      }),
      headers()
    )
  end

  def generate_response(prompt) do
    Logger.info("Generating response for prompt: #{prompt}")

    with {:ok, %{body: raw_body}} <- generate_endpoint(prompt),
         {:ok, %{"generations" => [generations]}} <- JSON.decode(raw_body) do
      generations |> Map.get("text") |> String.trim()
    else
      _ -> nil
    end
  end

  def generate_summary(prompt) do
    prompt =
      prompt
      |> Enum.map(fn %{"user" => user, "value" => value} -> "#{user}: #{value}" end)
      |> Enum.join("\n")

    Logger.info("Generating summary for prompt from cohere: #{prompt}")

    with {:ok, %{body: raw_body}} <- generate_summary_endpoint(prompt),
         {:ok, %{"summary" => summary}} <- JSON.decode(raw_body) do
      summary
    else
      _ -> nil
    end
  end

  def get_cohere_embedding(query) do
    query_message = query["value"]
    Logger.info("Getting embedding for query: #{query_message}")

    with {:ok, %{body: raw_body}} <- query_embeddings(query_message),
         {:ok, %{"embeddings" => [embedding]}} <- JSON.decode(raw_body) do
      embedding
    else
      _ -> nil
    end
  end
end
