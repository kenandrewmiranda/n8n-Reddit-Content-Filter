# 🔁 Reddit → Slack Content Filter Bot (n8n Workflow)

This open-source `n8n` workflow fetches posts from your favorite subreddits, filters for high-quality or enriching content, optionally summarizes long posts using OpenAI, and sends them to a Slack channel in a well-formatted block message.

---

## Author Notes

Feel free to optimize the flow by utilizing sub-flows for the reused nodes. Have fun!

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
- 🧵 Multi-branch logic to handle post filtering, summarization, and enrichment scoring
- 🤖 Uses OpenAI Assistants for summarization and judgment
- 🗂 Stores metadata and avoids duplicates via Supabase
- 📣 Sends messages to Slack using rich formatting

---

## 🚀 Getting Started

### 1. Clone This Repo

```bash
git clone https://github.com/your-username/reddit-to-slack-n8n.git
cd reddit-to-slack-n8n
```
2. Import into n8n
- Open your n8n instance
- Click Import Workflow
- Select reddit_content_flow.json

3. Run the SQL DDL (sql_script) in your Supabase / Postgres instance

📝 License

MIT License — feel free to fork and modify.

