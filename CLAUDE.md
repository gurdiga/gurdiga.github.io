# Ruby

Ruby is managed with rvm, and the version in `.ruby-version` is installed. The default shell `ruby` is the system 2.6, which can’t run `bundle`. Before any `bundle`, `jekyll` or `make` command:

```sh
source ~/.rvm/scripts/rvm && rvm use "$(cat .ruby-version)"
```

Each Bash call starts a fresh shell, so prefix every call that needs Ruby. Don’t use Homebrew Ruby: it’s 4.x, and `commonmarker` and `kramdown-parser-gfm` require `< 4.0`.

After pulling changes to `Gemfile.lock` (Dependabot merges often land), run `bundle install` before committing: the pre-commit hook runs `jekyll build` and fails with `Bundler::GemNotFound` if the installed gems are stale.
