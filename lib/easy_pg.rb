require "easy_pg/errors"
require "easy_pg/helpers"
require "easy_pg/railtie" if defined?(Rails)
require "easy_pg/version"

# rake tasks for dumping and restoring Postgres databases
#
# ## See:
#
# - [Rails rake tasks for dump & restore of PostgreSQL databases](https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90)
#   - [fork by @kofronpi](https://gist.github.com/kofronpi/37130f5ed670465b1fe2d170f754f8c6)
#   - [fork by @joelvh](https://gist.github.com/joelvh/f50b8462611573cf9015e17d491a8a92)
# - [`pg_dump` docs](https://www.postgresql.org/docs/11/app-pgdump.html)
# - [`pg_restore` docs](https://www.postgresql.org/docs/11/app-pgrestore.html)
# - [dumptruck](https://rubygems.org/gems/dumptruck)
# - [String#shellescape](https://apidock.com/ruby/v2_6_3/String/shellescape)
# - [How To Use Arguments In a Rake Task (with ZSH)](https://thoughtbot.com/blog/how-to-use-arguments-in-a-rake-task)
#
# ## Input/Output Formats
#
# - `p` (plain)
#     - Output a plain-text SQL script file (the default).
# - `c` (custom)
#     - Output a custom-format archive suitable for input into pg_restore.
#       Together with the directory output format, this is the most flexible output format in that it allows manual selection and reordering of archived items during restore.
#       This format is also compressed by default.
# - `d` (directory)
#     - Output a directory-format archive suitable for input into pg_restore.
#       This will create a directory with one file for each table and blob being dumped, plus a so-called Table of Contents file describing the dumped objects in a machine-readable format that pg_restore can read.
#       A directory format archive can be manipulated with standard Unix tools; for example, files in an uncompressed archive can be compressed with the gzip tool.
#       This format is compressed by default and also supports parallel dumps.
# `t` (tar)
#     - Output a tar-format archive suitable for input into pg_restore.
#       The tar format is compatible with the directory format: extracting a tar-format archive produces a valid directory-format archive.
#       However, the tar format does not support compression.
#       Also, when using tar format the relative order of table data items cannot be changed during restore.
module EasyPg; end
