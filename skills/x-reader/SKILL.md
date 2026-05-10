---
name: x-reader
description: Use when the user asks to read, inspect, summarize, or verify X/Twitter posts, quoted posts, public user profiles, recent X search results, or X API usage through the local X Reader MCP server.
---

# X Reader

Use this skill when Dan wants source-backed X context and the post is available through the X API.

Prefer this plugin over browser scraping for X posts because the API returns stable post ids, timestamps, authors, public metrics, quoted post ids, and expanded entities.

## Workflow

1. Extract the post id, username, or search query from the user's request.
2. Use the `x-reader` MCP tools for read-only access.
3. For quoted posts, fetch the quoted post too when the original result includes `referenced_tweets`.
4. Ask for clarification before using write-capable X tools. The default plugin allowlist should stay read-only.
5. Summarize the result with author, timestamp when useful, and the post's main claim.

## Default Read Tools

- `getPostsById`
- `getPostsByIds`
- `getPostsQuotedPosts`
- `searchPostsRecent`
- `getUsersById`
- `getUsersByIds`
- `getUsersByUsername`
- `getUsersByUsernames`
- `getUsersPosts`
- `getOpenApiSpec`
- `getUsage`

## Secrets

Credentials live in local `.env` only. Do not commit `.env`, print tokens, or paste token values into chat.
