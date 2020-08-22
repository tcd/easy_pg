##
# See:
#
# - [Rails rake tasks for dump & restore of PostgreSQL databases](https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90)
# - [`pg_dump` docs](https://www.postgresql.org/docs/11/app-pgdump.html)
# - [`pg_restore` docs](https://www.postgresql.org/docs/11/app-pgrestore.html)
namespace("easy_pg") do

  desc("Dumps the database to db/APP_NAME.dump")
  task(dump: :environment) do
    cmd = EasyPg::Dump.dump_cmd()
    puts(cmd)
    exec(cmd)
  end

  # https://thoughtbot.com/blog/how-to-use-arguments-in-a-rake-task
  desc("Restores the database dump at db/APP_NAME.dump.")
  task(:restore, [:file] => [:environment]) do |_task, args|
    if !args.file.present?()
      puts("Please pass a file name to the task")
    else
      Rake::Task["db:drop"].invoke()
      Rake::Task["db:create"].invoke()
      Rake::Task["db:migrate"].invoke()
      cmd = Lib::Dump.restore_cmd(dump_file: args.file)
      puts(cmd)
      exec(cmd)
    end
  end

  desc("List dumps")
  task(list_backups: :environment) do
    Lib::Dump.list_backups()
  end

end
