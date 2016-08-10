# rspec-syntax-updater
A simple ruby script for updating rspec syntax for your specs

To use, run in a terminal:

```bash
ruby update_rspec_syntax.rb <path>
```
where `<path>` can be a single `.rb` file or a directory. If you pass a directory, all top-level files in the directory will be processed

**Note:** Use it at your own risk - it will overwrite the files. Always check your specs work after running the script.
