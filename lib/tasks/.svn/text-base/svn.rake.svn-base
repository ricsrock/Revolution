namespace :svn do

  desc "Add files not under (sub)version control" 
  task :add do
    files = `svn st | grep \?`.map{|f| f.gsub(/\?\s+(.+)\n/){$1} }
    puts "No new files to add." and return if files.empty?
    files.each do |file|
      print "... #{file} [Yn]" 
     `svn add #{file}` unless STDIN.gets =~ /^n/i
    end
  end

end
