function "openai_create_embedding" {
  description = "Generate embeddings for text input"
  input {
    text input { description = "Text to generate embeddings for" }
    text model?="text-embedding-3-small" { description = "Embedding model (text-embedding-3-small, text-embedding-3-large, text-embedding-ada-002)" }
    int dimensions? { description = "Number of dimensions for the embedding (only for text-embedding-3-* models)" }
  }
  stack {
    var $params {
      value = {
        model: $input.model,
        input: $input.input
      }
    }
    var.update $params { value = $params|set_ifnotnull:"dimensions":$input.dimensions }

    api.request {
      url = "https://api.openai.com/v1/embeddings"
      method = "POST"
      headers = ["Authorization: Bearer " ~ $env.OPENAI_API_KEY, "Content-Type: application/json"]
      params = $params
      mock = {
        "creates embedding successfully": { response: { status: 200, result: { object: "list", data: [{ object: "embedding", index: 0, embedding: [0.0023, -0.0094, 0.0157] }], model: "text-embedding-3-small", usage: { prompt_tokens: 5, total_tokens: 5 } } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 200) {
      error_type = "standard"
      error = "OpenAI API error: " ~ $api_result.response.result
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "creates embedding successfully" {
    input = { input: "Hello world" }
    expect.to_equal ($response.object) { value = "list" }
    expect.to_not_be_null ($response.data)
  }
}