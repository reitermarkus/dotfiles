# frozen_string_literal: true

task :teamspeak do
  db = Pathname('~/Library/Application Support/TeamSpeak 3/settings.db').expand_path

  next unless db.exist?

  command 'sqlite3', db.to_path, <<~SQL
    REPLACE INTO Chat VALUES(#{Time.now.to_i}, "ReplaceSmilies", 0);
  SQL
end
