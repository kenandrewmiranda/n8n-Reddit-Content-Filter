-- =============================================
-- STEP 1: Create the user_subreddit_preferences table
-- =============================================

-- This table links each user to subreddits they follow,
-- and stores their preferred Reddit sort method.
-- It includes:
-- - Validated sort method
-- - Automatic timestamps
-- - Unique (user_id, subreddit) constraint to avoid duplicates
CREATE TABLE user_subreddit_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),   -- Unique identifier for each preference
  user_id UUID NOT NULL,                           -- The user this preference belongs to
  subreddit TEXT NOT NULL,                         -- Subreddit name (e.g., 'technology')
  sort_method TEXT NOT NULL DEFAULT 'hot'          -- Preferred sort method
    CHECK (sort_method IN ('new', 'top', 'hot', 'rising')),  -- Only accept allowed values
  created_at TIMESTAMPTZ DEFAULT now(),            -- Timestamp when the record was created
  updated_at TIMESTAMPTZ DEFAULT now(),            -- Timestamp for last update
  UNIQUE (user_id, subreddit)                      -- Ensure each user has only one preference per subreddit
);

-- ========================================================
-- STEP 2: Insert a test user preference into the new table
-- ========================================================

-- This is a sample record to verify everything works as expected.
-- It inserts a user preference for the subreddit 'n8n' with sort method 'hot'.
INSERT INTO user_subreddit_preferences (
  user_id,
  subreddit,
  sort_method
) VALUES (
  '6c8f2a36-fb1a-486a-8a45-5d574c7fba58', -- Sample user UUID
  'n8n',                                  -- Subreddit name
  'hot'                                   -- Sort method (valid: 'new', 'top', 'hot', 'rising')
);

-- =====================================================
-- STEP 3: Create a trigger to automatically update 'updated_at'
-- =====================================================

-- This function updates the `updated_at` timestamp every time the row is modified.
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to the user_subreddit_preferences table.
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON user_subreddit_preferences
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- STEP 4: Create the reddit_posts table
-- ============================================

-- This table stores Reddit posts pulled from Reddit’s API.
-- It includes:
-- - Post metadata (title, content, author)
-- - Post metrics (score, num_comments)
-- - Custom flags (is_enriching, shared_with_user)
-- - An LLM-generated summary field for later analysis
CREATE TABLE reddit_posts (
  id TEXT PRIMARY KEY,                   -- Reddit post ID (e.g., 't3_abc123')
  subreddit TEXT NOT NULL,              -- Subreddit where the post was found
  title TEXT NOT NULL,                  -- Post title
  selftext TEXT NOT NULL,               -- Post body/content
  url TEXT NOT NULL,                    -- Link to the post
  author TEXT NOT NULL,                 -- Reddit username of the author
  score INTEGER,                        -- Post score
  num_comments INTEGER,                 -- Number of comments
  is_self BOOLEAN,                      -- Whether it's a self-post (text) or a link post
  is_enriching BOOLEAN DEFAULT FALSE,   -- Custom flag for enriching content (e.g., AI-tagged)
  shared_with_user BOOLEAN,             -- Whether the post was shown/shared with the user
  summarized_output TEXT,               -- Optional LLM-generated summary for later evaluation
  created_utc INT8,                     -- Original post time in UTC from Reddit API
  fetched_at TIMESTAMPTZ DEFAULT now()  -- When this post was ingested into the system
);

-- Add an index to optimize queries by subreddit
CREATE INDEX idx_post_subreddit ON reddit_posts(subreddit);

-- ===============================================
-- STEP 5: Create a helper function to check if a post exists
-- ===============================================

-- This function returns:
-- { "exists": true } if the post ID is already in the reddit_posts table,
-- or { "exists": false } if it is not.
-- Useful for deduplication checks in automated workflows.
CREATE OR REPLACE FUNCTION check_post_exists(p_id TEXT)
RETURNS JSON
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN json_build_object(
    'exists', EXISTS (
      SELECT 1 FROM reddit_posts WHERE id = p_id
    )
  );
END;
$$;
