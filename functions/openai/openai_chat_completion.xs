function "openai_chat_completion" {
  description = "Generate a chat completion using GPT models"
  input {
    text model?="gpt-4o" { description = "Model ID (e.g. gpt-4o, gpt-4o-mini, gpt-3.5-turbo)" }
    json messages { description = "Array of message objects [{role: 'system', content: '...'}, {role: 'user', content: '...'}]" }
    decimal temperature?=1.0 { description = "Sampling temperature (0-2). Lower = more deterministic" }
    int max_tokens? { description = "Maximum tokens to generate in the response" }
    decimal top_p? { description = "Nucleus sampling (0-1). Alternative to temperature" }
    json tools? { description = "Array of tool/function definitions for function calling" }
    json response_format? { description = "Response format object, e.g. {type: 'json_object'}" }
  }
  stack {
    var $params {
      value = {
        model: $input.model,
        messages: $input.messages,
        temperature: $input.temperature
      }
    }
    var.update $params { value = $params|set_ifnotnull:"max_tokens":$input.max_tokens }
    var.update $params { value = $params|set_ifnotnull:"top_p":$input.top_p }
    var.update $params { value = $params|set_ifnotnull:"tools":$input.tools }
    var.update $params { value = $params|set_ifnotnull:"response_format":$input.response_format }

    api.request {
      url = "https://api.openai.com/v1/chat/completions"
      method = "POST"
      headers = ["Authorization: Bearer " ~ $env.OPENAI_API_KEY, "Content-Type: application/json"]
      params = $params
      mock = {
        "generates chat completion": { response: { status: 200, result: { id: "chatcmpl-abc123", object: "chat.completion", model: "gpt-4o", choices: [{ index: 0, message: { role: "assistant", content: "Hello! How can I help you today?" }, finish_reason: "stop" }], usage: { prompt_tokens: 12, completion_tokens: 9, total_tokens: 21 } } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 200) {
      error_type = "standard"
      error = "OpenAI API error: " ~ $api_result.response.result
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "generates chat completion" {
    input = { messages: [{ role: "user", content: "Hello" }] }
    expect.to_not_be_null ($response.id)
    expect.to_not_be_null ($response.choices)
    expect.to_equal ($response.model) { value = "gpt-4o" }
  }
}