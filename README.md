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
2. Import into n8n
Open your n8n instance
Click Import Workflow
Select reddit_flow_cleaned.json
🔐 Setup Instructions

Make sure to configure the following:

✅ Required Credentials
Integration	Description
Reddit OAuth2 API	Reddit App (script type) with client ID/secret and user login
Supabase API	Project URL + service role key
OpenAI API	API Key and 3 Assistants (Filter, Summarizer, Formatter)
Slack API	Bot token with chat:write + channels:read
See the Sticky Note in the workflow for full setup details.
🗃 Supabase Schema

You’ll need two tables and one RPC function:

user_subreddit_preferences
CREATE TABLE user_subreddit_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  subreddit TEXT NOT NULL,
  sort_method TEXT DEFAULT 'hot',
  created_at TIMESTAMPTZ DEFAULT now()
);
reddit_posts
CREATE TABLE reddit_posts (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL,
  subreddit TEXT,
  author TEXT,
  title TEXT,
  selftext TEXT,
  url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  summarized BOOLEAN DEFAULT FALSE,
  summarized_output TEXT,
  is_enriching BOOLEAN DEFAULT FALSE
);
RPC: check_post_exists
CREATE FUNCTION check_post_exists(post_id TEXT)
RETURNS TABLE(exists BOOLEAN)
LANGUAGE sql
AS $$
  SELECT EXISTS (SELECT 1 FROM reddit_posts WHERE id = post_id) AS exists;
$$;
🧪 Testing

Add a record to user_subreddit_preferences
Trigger the workflow manually
Check Slack for a formatted post or logs in Supabase for status


📝 License

MIT License — feel free to fork and modify.

