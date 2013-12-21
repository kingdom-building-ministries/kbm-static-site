# Guidelines

- All filenames should be lowercase with dash seperation for words.

  Amazon S3 is case sensitive, so you had better have a good reason for
  any capitals
    - If you are using git then you should probably set git to be case aware

      `git config --unset-all core.ignorecase`

      `git config --system core.ignorecase false`

## Special Note

`robots.txt` is set to deny all search engines. Once kbm.org goes live
we need to make sure this is set properly.

# Installing

The only external dependency right now is Imagemagick

    brew install imagemagick

# Running

Double click `serve.command'

Experience Joy at http://localhost:4000
