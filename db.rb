require 'sqlite3'
require 'terminal-table'

DATABASE = "billboard.db"

class BillboardDb
    def initialize
        @db = SQLite3::Database.new DATABASE
        createTable
    end

    def createTable
        @db.execute <<~SQL
            create table if not exists Charts (
                year int,
                rank int,
                song varchar(100),
                artist varchar(100)
            );
        SQL
    end

    def addSong(year, rank, song, artist)
        @db.execute "insert into Charts values (?, ?, ?, ?)", [ year, rank, song, artist]
    end

    def truncateTable
        @db.execute <<~SQL
            delete from Charts
        SQL
    end

    def query(where)
        results = @db.execute <<~SQL
            select * from Charts
            where #{where}
            order by year, rank
        SQL
        table = Terminal::Table.new :headings => ['year', 'rank', 'song', 'artist'], :rows => results
        puts ""
        puts table
    end
end