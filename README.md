
# 🔁 Reddit → Slack Content Filter Bot (n8n Workflow)

This open-source `n8n` workflow fetches posts from your favorite subreddits, filters for high-quality or enriching content, optionally summarizes long posts using OpenAI, and sends them to a Slack channel in a well-formatted block message.

---

## ✍️ Author Notes

Feel free to optimize the flow by using sub-flows for reused logic. Have fun!

---

## 📌 Use Case

Tired of wasting time scrolling Reddit for value-packed posts?

This automation:
- Pulls fresh posts from subreddits you subscribe to
- Filters posts based on upvote ratio and content quality
- Summarizes long posts
- Uses an OpenAI Assistant to decide whether a post is worth your attention
- Sends a clean, Slack-formatted message with metadata, summary, and link

---

## 🧠 Architecture

**Workflow Highlights:**
- 🧵 Multi-branch logic for filtering, summarization, and enrichment scoring
- 🤖 Uses OpenAI Assistants for summarization and judgment
- 🗂 Stores metadata and avoids duplicates via Supabase
- 📣 Sends messages to Slack using rich formatting

---

## 🚀 Getting Started

### 1. Clone This Repo

```
git clone https://github.com/kenandrewmiranda/reddit-content-filter-n8n.git
cd reddit-to-slack-n8n
```

### 2. Import the Workflow into n8n
- Open your `n8n` instance
- Click **Import Workflow**
- Select `reddit_content_flow.json`

### 3. Run the SQL DDL
Use the SQL script provided (`sql_script.sql`) in your Supabase or Postgres instance to set up the necessary schema.

---

## 🧩 Setup Instructions for Reddit → Slack Integration

Before running this workflow, complete the following setup steps:

### 🔐 Required Credentials

#### 1. **Reddit OAuth2 API**
- Create a Reddit app: [https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)
- App type: `script`
- Required values:
  - Client ID
  - Client Secret
  - Reddit Username and Password
- Add this to your `Reddit OAuth2 API` credential in n8n.

#### 2. **Supabase API**
- Create a project at [https://supabase.com](https://supabase.com)
- Go to Project Settings → API
- Use:
  - Project URL
  - Service Role Key
- Add as `Supabase API` credential in n8n.
- Run the SQL DDL script in the SQL Editor (found in the workflow sticky note or repo).

#### 3. **OpenAI API**
- Create 3 assistants at [https://platform.openai.com/assistants](https://platform.openai.com/assistants):
  - `Reddit Assistant` – for enrichment filtering
  - `Summarizer Agent` – for long post summaries
  - `Message Formatter` – for Slack formatting
- Add your API key to an `OpenAI API` credential in n8n.

#### 4. **Slack API**
- Create a Slack App: [https://api.slack.com/apps](https://api.slack.com/apps)
- Enable these OAuth scopes:
  - `chat:write`
  - `channels:read`
- Install the app to your workspace and invite it to your target channel.
- Add the bot token to a `Slack API` credential in n8n.

---

## 🔧 Node Customizations

- **Supabase - Check Post Exist**
  - Uses an RPC function (`check_post_exists`) to prevent reprocessing posts.
  - Ensure this function is created in your database.

- **Get User Subreddits**
  - Replace the hardcoded `user_id` (`6c8f2a36-fb1a-486a-8a45-5d574c7fba58`) with dynamic logic or looped user strategy if scaling.

- **Reddit Sorting**
  - Sorts posts based on the `sort_method` column in your user preferences table (e.g., `hot`, `top`, `new`).

- **Upvote Filter Threshold**
  - Filters out posts with `upvote_ratio <= 0.9`. You can adjust this threshold in the **Filter Upvote Ratio** node.

---

## 📝 License

MIT License — feel free to fork, remix, and improve.
