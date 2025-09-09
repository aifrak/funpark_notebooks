# Claude Code Instructions for FunPark Livebook Creation

## Project Overview
This is an advanced Elixir/LiveView educational project with:
- **BOOK.md**: Contains chapter text with embedded code examples and iex sessions
- **lib/**: Contains the actual FunPark modules (Ride, FastPass, Patron, etc.)
- **chapters/**: Livebook files (.livemd) for interactive learning
- **Docker setup**: Runs the compiled project with Livebook attached runtime

## Key Pattern: Extracting Interactive Examples from BOOK.md

When creating Livebook chapters from BOOK.md content, follow this pattern:

### 1. Identify Content Types in BOOK.md

**Display-Only (Markdown blocks):**
- Embedded code references: `<embed file="code/lib/fun_park/ride.ex" part="struct_and_make"/>`
- Bash commands: `~~~bash iex -S mix ~~~`
- Any code that shows structure but shouldn't execute

**Executable (Elixir cells):**
- iex examples: `iex> FunPark.Ride.make("Tea Cup", wait_time: 10)`
- Only extract the command part, NOT the expected output
- Students will see actual output by executing

**Skip entirely:**
- Book explanation text (that belongs in the book, not Livebook)
- Generic section headers like "Run It", "What We've Learned"
- Setup instructions that don't apply to the Docker environment

### 2. Livebook Structure Pattern

```markdown
# Chapter Title (from BOOK.md)

## Book Attribution Section
|                                                                                                    |                                                                                                                                                                              |
| -------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://www.joekoski.com/assets/images/jkelixir_small.jpg" alt="Book cover" width="120"> | **Interactive Examples from Chapter X**<br/>[Advanced Functional Programming with Elixir](https://pragprog.com/titles/jkelixir/advanced-functional-programming-with-elixir). |

## Section Title (meaningful sections only)

[Minimal FunPark context - one sentence max]

````markdown
```elixir
[Display-only code - struct definitions, partial examples]
```
````

[Terse action description like "Create a family-friendly ride:"]

```elixir
[Executable command from iex examples]
```

```elixir
[Another executable command]
```

## Next Section Title

[One sentence context]

````markdown
```elixir
[Display-only code]
```
````

[Terse action: "Create X:" or "Test Y:"]

```elixir
[Executable commands]
```
```

### 3. Docker Runtime Setup

**Key insight**: Students need access to the compiled project modules, equivalent to `iex -S mix`.

**Solution**: Two-container setup:
- `funxapp`: Runs compiled Mix project as distributed Elixir node
- `livebook`: Connects to funxapp as "attached runtime"

**Docker compose pattern**:
```yaml
services:
  funxapp:
    build: .
    hostname: funxapp.local
    command: ["sh", "-c", "elixir --name funx@funxapp.local --cookie secret-cookie --erl '-kernel inet_dist_listen_min 9000 inet_dist_listen_max 9000' -S mix run --no-halt"]
    
  livebook:
    image: ghcr.io/livebook-dev/livebook:0.17.1
    environment:
      LIVEBOOK_DEFAULT_RUNTIME: "attached:funx@funxapp.local:secret-cookie"
```

### 4. Critical Technical Details

**Erlang Distribution Requirements:**
- Use `--name` (not `--sname`) with FQDN: `funx@funxapp.local`
- Match hostnames exactly across containers
- Use consistent cookie across both containers
- Don't expose EPMD port 4369 (conflicts with host)

**Livebook Version Compatibility:**
- Use Livebook 0.17.1+ for Elixir 1.18.4 support
- Older versions (0.14.7) only support Elixir ~> 1.17.0

**Content Separation:**
- No `Mix.install([])` in Livebooks - modules loaded from attached runtime
- Display-only code uses ````markdown wrapper with ```elixir inside
- Executable code uses regular Elixir cells

### 5. Testing Commands Locally

Before Docker, test Elixir distributed node commands:
```bash
elixir --name funx@funxapp.local --cookie secret-cookie --erl "-kernel inet_dist_listen_min 9000 inet_dist_listen_max 9000" -S mix run --no-halt
```

### 6. Extraction Principles

- **Minimal business context only**: Just enough FunPark context for code to make sense - no more
- **Skip ALL theory**: No functional programming, no DDD, no design patterns - that's all in the book
- **Be literal with code**: Don't paraphrase or modify the actual code examples
- **Terse explanations**: One sentence max per concept (e.g., "FastPasses manage demand for popular rides")
- **Focus on hands-on**: Students execute actual commands, see real results
- **No methodology explanations**: Don't explain why we use certain approaches, just what things are
- **Attribution pattern**: Always include book cover + chapter reference table at the top
- **Business facts only**: What entities do, not how they're designed or why they matter conceptually

### 7. File Structure

```
/chapters/
  chap_01_funpark.livemd    # Chapter 1 interactive examples
  chap_02_*.livemd          # Future chapters...
  
docker-compose.yml          # Two-container setup
Dockerfile                  # Builds funxapp with compiled project
BOOK.md                     # Source material (don't modify)
lib/                        # Source code (don't modify)
```

This pattern ensures students get hands-on experience with the actual compiled modules while maintaining clear separation between book content (explanatory) and Livebook content (interactive).