require 'fileutils'
require 'time'
require 'sqlite3'

class Database_operations
	#To be changed
	Dir.chdir('db')

	def backup_database
		system_separator = "/"
		backup_src_file = "development.sqlite3" #Database file
		backup_src_path = Dir.pwd
		backup_src = backup_src_path + system_separator + backup_src_file

		backup_dest_file = Time.now.strftime("%Y%m%d%H%M%S") + "_" + backup_src_file #Output File
		backup_dest_path = Dir.pwd
		backup_dest = backup_dest_path + system_separator + backup_dest_file

		if File.exists?(backup_src)
			if File.file?(backup_src)
				db_backup = SQLite3::Database.new(backup_src)
				db_backup.transaction(:immediate) do |ignored| #Get shared lock
					FileUtils.cp backup_src, backup_dest, :preserve => true
				end
				db_backup.close
			else print "Error!"
			end
		else print "Error accessing file!"
		end
	end

	def restore_database
		system_separator = "/"
		print "Enter restoration source: "
		restore_src_file = gets.chomp #User input
		restore_src_path = File.dirname( restore_src_file )
		restore_src = restore_src_path + system_separator + restore_src_file

		restore_dest_file = "development.sqlite3" #Assume in db folder
		restore_dest_path = Dir.pwd 
		restore_dest = restore_dest_path + system_separator + restore_dest_file

		if File.exists?(restore_src)
			if File.file?(restore_src)
				db_restore = SQLite3::Database.new(restore_src)
				db_restore.transaction(:immediate) do |ignored|
					FileUtils.cp restore_src, restore_dest, :preserve => true
				end
				db_restore.close
			else print "Error!"
			end
		else print "Error accessing file!"
		end
	end
end

user_input = nil

loop do
print "Backup/Restore? "
user_input = gets.chomp.capitalize!
break if user_input.start_with?("R", "B")
end

if user_input.start_with?("R") then Database_operations.new.restore_database
elsif user_input.start_with?("B") then Database_operations.new.backup_database
else puts "Error!"
end

=begin
Database Backup/Restore v1.0
database_backup_restore.rb
May 2 2013
John Thomas Raphael DG Dulay

Possible modifications:
Backup source <- User Input
File Directory
Backup file name <- Editable
=end
