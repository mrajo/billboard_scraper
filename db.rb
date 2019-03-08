require 'sqlite3'

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
end