module EasyPg
  class Dump

    include Helpers

    # ==========================================================================
    # Tasks
    # ==========================================================================

    # @param log_output [Boolean]
    # @return [Array<String>]
    def self.list_dumps(log_output: true)
      dir   = self.backup_directory()
      path  = File.join(dir, "**", "*")
      paths = Dir.glob(path, File::FNM_DOTMATCH)
      files = paths.select { |e| File.file?(e) }
      files.sort!().reverse!()
      if log_output
        puts("backup_directory: #{dir}")
        puts()
        puts(files)
      end
      return files
    end

    # @param fmt [String]
    # @return [Hash{String => String}]
    def self.list_dumps_as_hash(fmt: "c")
      dir   = self.backup_directory()
      path  = File.join(dir, "**", "*")
      paths = Dir.glob(path, File::FNM_DOTMATCH)
      files = paths.select { |e| File.file?(e) }
      files.sort!().reverse!()
      options = {}
      files.map { |f| options[self.pretty_timestamp(File.basename(f, ".dump"))] = f }
      return options
    end

    # See:
    #
    # - [`pg_dump` docs](https://www.postgresql.org/docs/11/app-pgdump.html)
    #
    # @param fmt [String]
    # @param verbose [Boolean]
    #   This will cause pg_dump to:
    #     - output detailed object comments and start/stop times to the dump file
    #     - output progress messages to `stderr`
    # @return [String]
    def self.dump_cmd(fmt: "p", verbose: true)
      host = ActiveRecord::Base.connection_config[:host]
      db   = ActiveRecord::Base.connection_config[:database]
      # user = ActiveRecord::Base.connection_config[:username]
      # pass = ActiveRecord::Base.connection_config[:password]
      user = (ActiveRecord::Base.connection_config[:username] || "postgres")
      pass = (ActiveRecord::Base.connection_config[:password] || "postgres")
      dump_file = self.file_name(db: db, fmt: fmt)
      return [
        "PGPASSWORD='#{pass}'",
        # https://www.postgresql.org/docs/11/app-pgdump.html
        "pg_dump",
        # Host name of the machine on which the DB server is running
        "--host=#{host}",
        # User name to connect as
        (user.blank? ? nil : "--username"),
        (user.blank? ? nil : user),
        # Specifies verbose mode.
        (verbose ? "--verbose" : nil),
        # Output commands to clean (drop) database objects prior to outputting the commands for creating them
        # "--clean",
        # Don't set ownership of objects to match the original database
        # (So that can use the output with `pg_restore`)
        "--no-owner",
        # Prevent dumping of access privileges (grant/revoke commands)
        # (same as `--no-privileges`)
        "--no-acl",
        # Dump object identifiers (OIDs) as part of the data for every table
        # Use this option if your application references the OID columns in some way (e.g., in a foreign key constraint)
        # "-o",
        # Output a custom-format archive suitable for input into pg_restore
        "--format=#{fmt}",
        db,
        ">",
        dump_file,
      ].compact.join(" ")
    end

    # See:
    #
    # - [`pg_restore` docs](https://www.postgresql.org/docs/11/app-pgrestore.html)
    #
    # @param dump_file [String]
    # @param verbose [Boolean]
    # @return [String]
    def self.restore_cmd(dump_file: nil, verbose: true)
      host = ActiveRecord::Base.connection_config[:host]
      db   = ActiveRecord::Base.connection_config[:database]
      # user = ActiveRecord::Base.connection_config[:username]
      # pass = ActiveRecord::Base.connection_config[:password]
      user = (ActiveRecord::Base.connection_config[:username] || "postgres")
      pass = (ActiveRecord::Base.connection_config[:password] || "postgres")
      dump_file ||= self.file_name(db: db)
      return [
        "PGPASSWORD='#{pass}'",
        # https://www.postgresql.org/docs/11/app-pgrestore.html
        "pg_restore",
        # "--disable-triggers",
        # Specifies verbose mode.
        (verbose ? "--verbose" : nil),
        # Host name of the machine on which the DB server is running.
        "--host=#{host}",
        # User name to connect as.
        (user.blank? ? nil : "--username=#{user}"),
        # Clean (drop) database objects before recreating them.
        # "--clean",
        # Do not set ownership of objects to match the original database.
        "--no-owner",
        # Prevent restoration of access privileges (grant/revoke commands).
        "--no-acl",
        # Connect to database `dbname` and restore directly into the database.
        "--dbname=#{db}",
        dump_file,
      ].compact.join(" ")
    end

  end
end
