# Concrete arbitrage examples

Illustrations by domain — use as a reference when the user asks "show me a case".

## Product

### "If a message is detected as corporate, apply the bullshit translator"

> **[ARBITRAGE]** "corporate message = bullshit" is a bet (~80% true). A sincere HR note or a factual technical memo would be over-translated. A confidence slider > a binary if/else?

### "Users never read the ToS, skip the screen"

> **[ARBITRAGE]** "never" is a heuristic. B2B / legal users do read. Skipping = legal risk if consent is contested. Option: show with a fast-track, don't remove.

## Code

### `if language == "fr": apply_formal_tone()`

> **[ARBITRAGE]** "French = formal tone" is a cultural bet. Quebec, francophone Africa, French startups all use different registers. A formality score, or a user param, beats an if/else on language.

### `if retries > 3: raise FatalError()`

> **[ARBITRAGE]** "3 retries is enough" is a heuristic magic number. Mobile networks, slow APIs at peak — 3 isn't enough. Exponential backoff with a configurable timeout beats a fixed threshold.

## Data / DB

### "Store the preferred musical genre in a single field"

> **[ARBITRAGE]** "one artist = one genre" is a bet. 40%+ of artists are multi-genre. Single field → signal loss. Use an array or a join table.

### "The `status` field is an enum: active, inactive"

> **[ARBITRAGE]** "two states are enough" is true now. But `suspended`, `pending_review`, `archived` show up in 3 months. A non-extensible enum = painful migration. Plan for it, or document the constraint.

## Prompt engineering

### "The prompt says: 'Always answer in 3 paragraphs'"

> **[ARBITRAGE]** "3 paragraphs = good answer" is a format heuristic. Some answers are best in one line, others in ten. A rigid constraint → degraded quality on edge cases. "Between 1 and 5 paragraphs depending on complexity" beats a fixed rule.

### "You are a senior expert with 20 years of experience"

> **[ARBITRAGE]** "senior expert = best answer" is a persona heuristic. It works for technical questions. For creativity or popularisation, it bottlenecks. Adapt persona to task type > a single hardcoded persona.

## Cases where NO arbitrage is needed

### "Add a unique index on the email column"

*silence*. Clear algorithmic contract — no heuristic to challenge.

### "When `user.role == 'admin'`, allow access to the dashboard"

*silence*. Closed contract on a controlled enumeration.

---

## How to write a good example

A useful entry has three parts:

1. **The line under fire** (a literal piece of code, spec, or prompt)
2. **Why it's a bet, not a contract** (the unstated premise, the population it ignores)
3. **A concrete alternative** that turns the bet into a setting, a score, or a documented decision

Avoid abstract examples — the skill earns its keep when readers see their own code in a callout.
