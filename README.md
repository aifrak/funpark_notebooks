# FunPark Interactive Examples

Interactive notebooks for [Advanced Functional Programming with Elixir](https://pragprog.com/titles/jkelixir/advanced-functional-programming-with-elixir).

## Chapters

| Launch | Description |
|--------|-------------|
| ▶️ [Chap 1](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_01_funpark.livemd) | Model the domain – rides, patrons, fast passes |
| ▶️ [Chap 2](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_02_eq.livemd) | Implement flexible equality with `Eq` |
| ▶️ [Chap 3](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_03_ord.livemd) | Express sorting and comparison with `Ord` |
| ▶️ [Chap 4](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_04_monoid.livemd) | Combine with associative monoids |
| ▶️ [Chap 5](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_05_predicate.livemd) | Build composable logic with predicates |
| ▶️ [Chap 6](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_06_monad.livemd) | Sequence operations using monads |
| ▶️ [Chap 7](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_07_reader.livemd) | Inject context with the Reader monad |
| ▶️ [Chap 8](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_08_maybe.livemd) | Model optional data with `Maybe` |
| ▶️ [Chap 9](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_09_either.livemd) | Handle success and failure with `Either` |
| ▶️ [Chap 10](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2FJKWA%2Ffunpark_notebooks%2Fblob%2Fmain%2Fchapters%2Fchap_10_effect.livemd) | Combine async + error handling with `Effect` |

## Running Locally with Docker (Optional)

If you want to run the notebooks in your local Docker environment, follow these steps:

1. Clone this repository:

   ```sh
   git clone https://github.com/JKWA/funpark_notebooks.git
   cd funpark_notebooks
   ```

2. Start Livebook using Docker Compose:

   ```sh
   docker compose up
   ```

3. Open your browser to [http://localhost:8090](http://localhost:8090)

4. Login password:

   ```
   funpark_12char
   ```

This is only needed if you want to run the notebooks locally using Docker. For most users, the Launch links above are the fastest way to explore each chapter.
