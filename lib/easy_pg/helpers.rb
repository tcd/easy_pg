require "fileutils"
require "time"

module EasyPg
  # Helper methods
  class Helpers

    # @param create [Boolean] Create the directory if it does not exist.
    # @return [Pathname]
    def self.backup_directory(create = true)
      dir = Rails.root.join("db", "dumps")
      if create && !Dir.exist?(dir)
        puts("Creating #{dir}")
        FileUtils.mkdir_p(dir)
      end
      return dir
    end

    # @param backup_dir [Pathname]
    # @param fmt [String]
    # @param db [String]
    # @return [String]
    def self.file_name(backup_dir:, fmt: "c", db:)
      extension = suffix_for_format(fmt)
      file_name = "#{timestamp()}.#{db}.#{extension}"
      return backup_dir.join(file_name)
    end

    # Return the file extension associated with a given pg_dump output format.
    #
    # @param suffix [String]
    # @return [String]
    def self.extension_from_format(suffix)
      return case suffix
             when "c" then "dump"
             when "p" then "sql"
             when "t" then "tar"
             when "d" then "dir"
             end
    end

    # Determine the pg_dump output format associated with a file extension.
    #
    # @param file [String,Pathname]
    # @return [String]
    def self.format_from_extension(file)
      file = file.to_s() if file.is_a?(Pathname)
      return case file.downcase
             when /\.dump$/ then "c"
             when /\.sql$/  then "p"
             when /\.dir$/  then "d"
             when /\.tar$/  then "t"
             end
    end

    # Pull DB config from ActiveRecord.
    #
    # @yieldparam app [String]
    # @yieldparam host [String]
    # @yieldparam db [String]
    # @yieldparam user [String]
    # @yieldparam password [String]
    # @return [void]
    def self.with_active_record_config()
      yield Rails.application.class.module_parent_name.underscore,
            ActiveRecord::Base.connection_config[:host],
            ActiveRecord::Base.connection_config[:database],
            ActiveRecord::Base.connection_config[:username],
            ActiveRecord::Base.connection_config[:password]
      # (ActiveRecord::Base.connection_config[:username] || "postgres"),
      # (ActiveRecord::Base.connection_config[:password] || "postgres")
    end

    # @param format_string [String]
    # @return [String]
    def self.timestamp(format_string = "%Y-%m-%d-%H_%M_%S")
      # 2020-07-27-13_17_35
      # return Time.zone.now.strftime("%Y%m%d%H%M%S")
      return Time.zone.now.strftime(format_string)
    end

    # See:
    #
    # - [`Time#strftime`](https://ruby-doc.org/core-2.6.5/Time.html#method-i-strftime)
    # - [`Integer#ordinalize`](https://api.rubyonrails.org/v5.1/classes/Integer.html#method-i-ordinalize)
    #
    # @param timestamp [String]
    # @param format_string [String]
    # @return [Time]
    def self.pretty_timestamp(timestamp, format_string = "%Y-%m-%d-%H_%M_%S")
      time = Time.zone.strptime(timestamp, format_string)
      return time.strftime("%A, %B #{time.day.ordinalize} %Y %r - #{timestamp[20..-1]}")
    end

  end
end
