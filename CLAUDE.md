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

### 4. Current Architecture (UPDATED)

**Simplified Approach - Mix.install per user:**
- Single Livebook container with multi-user support
- Each student forks notebooks and gets isolated runtime via Mix.install
- FunPark library mounted read-only as `/mnt/funpark_lib`

**Docker setup:**
```yaml
services:
  livebook:
    image: ghcr.io/livebook-dev/livebook:0.17.1
    environment:
      LIVEBOOK_MULTI_USER: "true"
      LIVEBOOK_TOKEN_ENABLED: "true"
      LIVEBOOK_PASSWORD: "student2024!"
    volumes:
      - ./chapters:/data/chapters:ro           # Read-only source notebooks
      - ./funpark_lib:/mnt/funpark_lib:ro      # Read-only library code
```

**Notebook pattern:**
```elixir
Mix.install([
  {:fun_park,
    git: "https://github.com/JKWA/funpark_notebooks.git",
    branch: "main",
    sparse: "code"
  }
])
```

**Benefits:**
- Each student gets isolated runtime when they fork
- No complex distributed Erlang setup
- Students can experiment without affecting others
- Authentication captures user emails
- Simple management and debugging

### 5. Testing Commands Locally

Before Docker, test Elixir distributed node commands:
```bash
elixir --name funx@funxapp.local --cookie secret-cookie --erl "-kernel inet_dist_listen_min 9000 inet_dist_listen_max 9000" -S mix run --no-halt
```

### 6. Extraction Principles (REFINED)

**Core Rule**: This is a supplement to the book, not a replacement. Assume students have the book for all explanations.

**What to Extract:**
- All iex examples from `{:style="shaded"}` blocks - these become executable Elixir cells
- Embedded code references (like `<embed file="..."/>`) - these become display-only markdown blocks
- Just enough FunPark story context to make the iex examples meaningful

**What NOT to Extract:**
- Technical explanations (protocols, DDD, functional programming theory) - that's in the book
- Domain expert methodology ("After talking with our Ride expert") - that's DDD teaching, belongs in book
- Expected output from iex examples - students will see real output by executing
- Business justifications or architectural reasoning - that's all covered in the book

**Context Pattern (Follow Chapter 4 Monoid as Gold Standard):**
- Use the book's EXACT language for action/result descriptions
- "Use `Monoid.wrap/2` to lift raw values into the monoid context:" (direct from book)
- "And `max/1` solves our `Ride` expert's daily report from a ride's wait time log:" (direct from book)
- "The Max Monoid also works when there is only a single patron in the list:" (direct from book)

**Style Guidelines:**
- Use the book's precise wording for context around iex examples
- Action + expected result pattern, using book language
- Remove all DDD language ("expert", "bounded context", "domain") UNLESS it's part of the exact book text
- Remove all functional programming concepts explanations
- Keep business entity facts: "Rides have names", "FastPasses have times", "Patrons have ticket tiers"
- Extract the book's narrative language around examples verbatim

**Complete iex Coverage:**
- Extract ALL iex examples from the chapter, even if they seem repetitive
- Some examples test edge cases or show progression (like Alice upgrading tickets)
- Each iex command becomes one Elixir cell (don't combine multiple commands)

### 7. File Structure

```
/chapters/
  chap_01_funpark.livemd    # Chapter 1 interactive examples
  chap_02_eq.livemd         # Chapter 2 equality examples
  chap_03_ord.livemd        # Chapter 3 ordering examples  
  chap_04_monoid.livemd     # Chapter 4 monoid examples (GOLD STANDARD)
  
docker-compose.yml          # Single-container setup with multi-user
BOOK.md                     # Source material (don't modify)
lib/                        # Source code (don't modify)
```

### 8. Chapter 4 Monoid as the Perfect Example

**chap_04_monoid.livemd** represents the ideal extraction pattern:

- **Exact book language**: Uses phrases directly from BOOK.md like "Use `Monoid.wrap/2` to lift raw values into the monoid context"
- **Minimal context**: Only includes action/result language from the book, no additional explanations
- **Complete iex coverage**: Every iex example from the chapter is included as executable cells
- **Proper code separation**: Display-only code in markdown blocks, executable examples in Elixir cells
- **Book attribution**: Standard header with cover image and chapter reference

**Use this as the template for all future chapters.** When extracting new chapters, refer to chap_04_monoid.livemd for the exact style and approach.

This pattern ensures students get hands-on experience with the actual compiled modules while maintaining clear separation between book content (explanatory) and Livebook content (interactive).