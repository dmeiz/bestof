require 'rubygems'
require 'sinatra'
require 'haml'
require 'mp3info'

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
  mime_type, apic = pop(apic)  # mime type
  apic = apic[1..-1]           # picture type
  desc, apic = pop(apic)       # description

  base = File.basename(mp3_name, ".mp3")

  ext = case(mime_type)
    when /jpeg/ then "jpg"
    when /png/ then "png"
    else raise "Unknown mime type #{mime_type}"
  end

  filename = "public/#{base}.#{ext}"

  File.open(filename, "w") do |f|
    f.write(apic)
  end

  filename
end

# Extracts interesting attributes from an mp3 and returns them in a hash.
def mp3_atts(filename)
  atts = {
    :filename => "mp3s/" + File.basename(filename)
  }

  Mp3Info.open(filename) do |info|
    %w(artist title album year).each do |key|
      atts[key.to_sym] = info.tag1[key]
    end

    if apic = info.tag2["APIC"]
      atts[:image_filename] = File.basename(apic_to_file(apic, filename))
    end
  end

  atts
end

@@songs = []

Dir.glob("public/mp3s/*.mp3") do |filename|
  @@songs << mp3_atts(filename)
end

@@songs.sort {|a,b| a[:filename] <=> b[:filename]}

get "/" do
  @songs = @@songs
  haml :index
end

get "/playlist.m3u" do
  content_type "audio/x-mpegurl"
  @@songs.collect {|song| "http://#{request.host}/#{song[:filename]}"}.join("\n")
end

