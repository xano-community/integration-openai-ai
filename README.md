# OpenAI Integration for Xano

Generate AI-powered text completions and vector embeddings from your Xano backend using GPT models.

## Functions

| Function | Description |
| --- | --- |
| `openai_chat_completion` | Generates a chat completion response using a GPT model. |
| `openai_create_embedding` | Generates a vector embedding for the given input text. |

## Install

### Option A — Ask Claude Code

With the [Xano MCP](https://github.com/xano-labs/mcp-server) enabled in Claude Code, paste this into Claude:

> Install the integration at https://github.com/xano-community/integration-openai-ai into my Xano workspace.

Claude will clone the repo and push the functions to your workspace.

### Option B — Use the Xano CLI

1. Install and authenticate the [Xano CLI](https://docs.xano.com/cli):
   ```sh
   npm install -g @xano/cli
   xano auth
   ```

2. Clone and push this integration:
   ```sh
   git clone https://github.com/xano-community/integration-openai-ai.git
   cd integration-openai-ai
   xano workspace:push . -w <your-workspace-id>
   ```

   Replace `<your-workspace-id>` with the ID from `xano workspace:list`.

## Configure Credentials

1. Create an OpenAI account at https://platform.openai.com/signup
2. Navigate to API Keys in your account settings
3. Click Create new secret key and copy it immediately (it won't be shown again)
4. Add a payment method under Billing to enable API usage
5. In Xano, set the environment variable OPENAI_API_KEY to your secret key

Environment variables used by this integration:

- `OPENAI_API_KEY`

See `.env.example` for a template.

## Usage

Call any function from another function, task, or API endpoint using `function.run`:

```xs
function.run "openai_chat_completion" {
  input = {
    // See function signature for required parameters
  }
} as $result
```

## Function Reference

### `openai_chat_completion`

Sends a conversation history to OpenAI's Chat Completions API and returns the model's response. Accepts an array of messages with roles (system, user, assistant) and supports model selection, temperature, and max token configuration. Use it to build chatbots, generate content, summarize text, or add AI-powered features to any Xano workflow.

### `openai_create_embedding`

Converts text into a numerical vector representation using OpenAI's embedding models. Returns an OpenAI embeddings response object; the vector is at data[0].embedding. Ideal for building semantic search, recommendation systems, and content similarity features. Store the resulting vectors in Xano's database for efficient similarity queries.

## License

MIT — see [LICENSE](./LICENSE).
