require 'rake'
require 'pp'

################################################################################################
# constants

ROOT_DIR = File.expand_path('.')
ENGLISH_LPROJ = File.join(ROOT_DIR, 'app', 'en.lproj')
TOTALSPACES2_DEV = File.join(ROOT_DIR, "..", "TotalSpaces2", "TotalSpaces2")

################################################################################################
# dependencies

begin
  require 'colored'
rescue LoadError
  raise 'You must "gem install colored" to use terminal colors'
end

################################################################################################
# helpers

def die(msg, status=1)
  puts "Error[#{status||$?}]: #{msg}".red
  exit status||$?
end

def sys(cmd)
  puts "> #{cmd}".yellow
  system(cmd)
end

################################################################################################
# routines

def parse_strings_file(filename)
  lines = []
  if File.exists? filename then
    File.open(filename, "r") do |f|
      f.each do |line|
        lines << line
      end
    end
  end
  lines
end

def inprint_strings(source, dest, shared_originals=[])
  strings = parse_strings_file(source)
  originals = []
  originals.concat shared_originals
  originals.concat parse_strings_file(dest)

  # transform lang back to english
  index = 0
  strings.map! do |line|
    index+=1
    next line unless (line.strip[0...1]=='"')

    line =~ /^\s*?(".*")\s*?=\s*?(".*")\s*?;\s*?/
    die "syntax error in " + source.blue+":"+index.to_s unless $1

    line = $1 + " = " + $1 + ";\n";

    line
  end

  # replace translations we already know from previsous version
  index = 0
  originals.each do |original|
    index+=1
    next unless (original.strip[0...1]=='"')

    original =~ /^\s*?(".*")\s*?=\s*?(".*")\s*?;(.*)$/
    needle = $1
    haystack = $2
    rest = $3
    die "syntax error in " + dest.blue+":"+index.to_s unless $1 and $2

    found = false
    strings.map! do |line|
      if (line.index needle) == 0 then
        line = needle + " = " + haystack + ";" + rest + "\n";
        found = true
      end

      line
    end
  end

  File.open(dest, "w") do |f|
    f << strings.join
  end

  strings
end

def propagate_english_to_cwd
  puts Dir.pwd.blue
  total = 0
  
  all = []
  
  Dir.glob(File.join(ENGLISH_LPROJ, "*.strings")) do |file|
    all.concat parse_strings_file(File.join(Dir.pwd, File.basename(file)))
  end

  Dir.glob(File.join(ENGLISH_LPROJ, "*.strings")) do |file|
    puts "  #{File.basename(file)}".yellow
    total += inprint_strings(file, File.join(Dir.pwd, File.basename(file)), all).size
  end

  puts "  -> "+total.to_s.green+" strings processed"
end

def propagate_from_english_to_other_lprojs
  glob = ENV["to"] || "*.lproj"

  Dir.glob(File.join(ROOT_DIR, 'app', glob)) do |dir|
    next if dir =~ /en.lproj/
    Dir.chdir dir do
      propagate_english_to_cwd
    end
  end
end

def validate_strings_file path
  lines = parse_strings_file(path)

  in_multi_line_comment = false
  counter = 0
  count = lines.size
  lines.each do |line|
    counter += 1
    if in_multi_line_comment and line =~ /.*\*\/\w*$/
      in_multi_line_comment = false
      next
    end
    next if in_multi_line_comment
    next if line =~ /^".*?"\s*=\s*".*?";\s*$/
    next if line =~ /^".*?"\s*=\s*".*?";\s*\/\*.*?\*\/$/
    next if line =~ /^".*?"\s*=\s*".*?";\s*\/\/.*?$/
    next if line =~ /^\/\*.*?\*\/$/
    next if line =~ /^$/
    # last line may be without new-line character
    next if counter==count and line =~ /^".*?"\s*=\s*".*?";\s*/
    next if counter==count and line =~ /^".*?"\s*=\s*".*?";\s*\/\*.*?\*\//
    next if counter==count and line =~ /^".*?"\s*=\s*".*?";\s*\/\/.*?$/
    if line =~ /^\/\*[^\*]*/ then
      in_multi_line_comment = true
      next
    end

    puts "line ##{counter}: unrecognized pattern".red+" (fix rakefile if this is a valid pattern)"
    puts line
    puts "mate -l #{counter} \"#{path}\"".yellow
    return false
  end

  true
end

def validate_strings_files
  begin
    require 'cmess/guess_encoding'
  rescue LoadError
    die 'You must "gem install cmess" to use character encoding detection'
  end

  glob = ENV["to"] || "*.lproj"

  counter = 0
  failed = 0
  warnings = 0

  known_files = []
  Dir.glob(File.join(ENGLISH_LPROJ, "*")) do |path|
    known_files << File.basename(path)
  end

  Dir.glob(File.join(ROOT_DIR, 'app', "*.lproj")) do |dir|
    unrecognized_files = []
    missing_files = known_files.dup

    Dir.glob(File.join(dir, "*")) do |path|
      file = File.basename(path)

      if missing_files.include?(file) then
        missing_files.delete(file)
      else
        unrecognized_files << file
      end
    end

    if (!missing_files.empty? or !unrecognized_files.empty?) then
      warnings += 1

      puts "in " + dir.blue + ":"
      if (!missing_files.empty?) then
        puts "  missing files: " + missing_files.join(", ")
      end
      if (!unrecognized_files.empty?) then
        puts "  unrecognized files: " + unrecognized_files.join(", ")
      end
    end
  end

  Dir.glob(File.join(ROOT_DIR, 'app', glob, "*.strings")) do |path|
    counter += 1
    ok = 1
    input   = File.read path
    charset = "ASCII"
    if input.strip.size>0 then
      charset = CMess::GuessEncoding::Automatic.guess(input)
      ok = ((validate_strings_file path) and (charset=="ASCII" or charset=="UTF-8"))
    end
    puts charset.magenta+" "+path.blue+" "+"ok".yellow if ok
    puts charset.magenta+" "+path.blue+" "+"failed".red unless ok
    failed +=1 unless ok
  end

  puts "-----------------------------------"
  puts "checked "+"#{counter} files".magenta+" and "+(failed>0 ? ("#{failed} failed".red) : ("all is ok".yellow)) + (warnings>0?(" [#{warnings} warnings]".green):(""))
end

def import_ib_strings
  %x{mkdir -p "#{File.join(ROOT_DIR, "built")}"}
  
  Dir.glob(File.join(ROOT_DIR, 'app', "*.lproj")) do |dir|
    dirname = File.basename(dir)
    destdir = File.join(ROOT_DIR, "built", dirname)
    %x{mkdir -p "#{destdir}"}

    FileUtils.cp(File.join(dir, "LicensingInfo.html"), destdir)
    FileUtils.cp(File.join(dir, "Localizable.strings"), destdir)
  end
  
  ibstrings_outdir = File.join(ROOT_DIR, "ib_strings");
  Dir.glob(File.join(ROOT_DIR, "../TotalSpaces2/TotalSpaces2/Base.lproj/*.xib")) do |ibfile|
    name = File.basename(ibfile)[/^[^\.]*/]
    outfile_utf16 = File.join(ibstrings_outdir, "#{name}.strings.utf16")
    outfile_utf8 = File.join(ibstrings_outdir, "#{name}.strings")
    %x{ibtool --export-strings-file #{outfile_utf16} #{ibfile}}
    contents_16 = File.read(outfile_utf16, open_args: ['rb:utf-16'])
    contents_8 = contents_16.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
    File.write(outfile_utf8, contents_8)
    File.unlink(outfile_utf16)
  end

  Dir.glob(File.join(ROOT_DIR, "ib_strings", "*.strings")) do |ib_strings_file|
  
    ibstrings = parse_strings_file(ib_strings_file)
  
    ibitems = {}
    expect = false
    oid = text = title = comment = ""
    ibstrings.each do |line|
      if expect
        ibitems["#{oid}.#{title}"] = [line.strip, text, comment.strip, false]
        expect = false 
      elsif line =~ /^\/\* Class = "\w+"; (.*) = "(.*)"; ObjectID = "([-\w]+)"; \*\//
        title,text,oid = $1,$2,$3
        comment = line
        expect = true
      end
    end
  
    Dir.glob(File.join(ROOT_DIR, 'app', "*.lproj")) do |dir|
      dirname = File.basename(dir)
      destdir = File.join(ROOT_DIR, "built", dirname)

      lang_strings = parse_strings_file(File.join(destdir, "Localizable.strings"))
    
      f = File.open(File.join(destdir, File.basename(ib_strings_file)), "w")
    
      comment = ""
      lang_strings.each do |line|
        next if line.strip[0...1] != '"'
      
        line =~ /^\s*"(.*)"\s*=\s*(".*")\s*;.*$/
        original_text = $1
        translated_text = $2 # includes quotes
      
        ibitems.each do |key, info|
          if !info[3] && info[1] == original_text
            f.puts info[2]
            f.puts "\"#{key}\" = #{translated_text};"
            f.puts ""
            info[3] = true
          end
        end
      end
    
      f.close
    
      %x{cp -R "#{destdir}" "#{TOTALSPACES2_DEV}"}
    
      ibitems.each do |key, info|
        info[3] = false
      end
    end
  end
end

################################################################################################
# tasks

desc "switch /Applications/TotalSpaces.app into dev mode"
task :dev do
  if !ARGV[1] || ARGV[1].length < 2
    puts "You must supply the language code you are working on"
    exit
  end

  sys("./bin/dev.sh '#{ARGV[1]}'")
  
  exit  # stop rake running ARGV[1] as a task
end

desc "switch /Applications/TotalSpaces.app into non-dev mode"
task :undev do
  if !ARGV[1] || ARGV[1].length < 2
    puts "You must supply the language code you are working on"
    exit
  end
  
  sys("./bin/undev.sh '#{ARGV[1]}'")
  
  exit  # stop rake running ARGV[1] as a task
end

desc "restart TotalSpaces.app"
task :restart do
  sys("./bin/restart.sh")
end

desc "propagates structure of English.lproj to all other language folders while keeping already translated strings"
task :propagate do
  propagate_from_english_to_other_lprojs
end

desc "validates all strings files and checks them for syntax errors"
task :validate do
  validate_strings_files
end

desc "import strings from ib"
task :ibimport do
  import_ib_strings
end
