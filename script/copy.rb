def copy(filename, track_number)
  puts %Q(scp "#{filename}" dev@bestof.methodhead.com:/u/apps/bestof/shared/mp3s/)
end

track_number = 1
File.open("playlist.txt") do |f|
  f.each_line do |line|
debugger
    next if line =~ /Name\w+Artist/
    fields = line.split("\t")
    if fields[26]
      copy(fields[26].strip, track_number)
      track_number += 1
    end
  end
end
