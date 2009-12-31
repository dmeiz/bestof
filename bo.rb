require 'rubygems'
require 'sinatra'
require 'haml'
require 'mp3info'

@music = [
  {:artist => "The Ponys", :title => "Harakiri", }
]


=begin
Mp3Info.open("public/10 Harakiri.mp3") {|info| apic = info.tag2["APIC"]}
img = apic[14..-1]
File.open("img.jpg", "w") {|f| f.write img}

"0foo" "", "foo"
"00foo"
=end

# Removes 0-delimited value from string, returning that value and the resulting
# string.
def pop(s)
  i = s.index(0)
  [s[0..i], s[(i + 1)..-1]]
end

# Extracts image from apic data and saves it to public/ using mp3_name as hint
# for the name.  Returns the filename.
def apic_to_file(apic, mp3_name)
  apic = apic[1..-1]           # encoding
  mime_type, apic = pop(apic) # mime type
  apic = apic[1..-1]           # picture type
  desc, apic = pop(apic)      # description

  base = File.basename(mp3_name, ".mp3")

  ext = case(mime_type)
    when /jpeg/ then "jpg"
    when /png/ then "png"
    else raise "Unknown mime type #{mime_type}"
  end

  File.open("public/#{base}.#{ext}", "w") do |f|
    f.write(apic)
  end
end

# Extracts interesting attributes from an mp3 and returns them in a hash.
def mp3_atts(filename)
  atts = {}
  Mp3Info.open(filename) do |info|
    %w(artist title album year).each do |key|
      atts[key.to_sym] = info.tag1[key]
    end

    if apic = info.tag2["APIC"]
      apic_to_file(apic, filename)
    end
  end
  atts
end

Dir.glob("public/*.mp3") do |filename|
  puts mp3_atts(filename)
end

get "/" do
  haml :index
end

