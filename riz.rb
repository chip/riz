# !/usr/bin/env ruby

# brew location
BREW = '/opt/homebrew/bin/brew'.freeze
# Ruby environment vars for installing docs
ENV['RUBY_CONFIGURE_OPTS'] = "--with-libyaml-dir=#{`#{BREW} --prefix libyaml`.strip} --enable-install-doc"
ENV['RI_BASE_DIR'] = "#{ENV['HOME']}/.local/share/rdoc"

# Ruby docs with color
def riz(arg)
  if arg.nil? || arg.empty?
    puts 'riz needs a Ruby method or class as an argument (Array, Array#map, map)'
    return
  end

  # Pass argument to Ruby documentation API CLI
  # Remove backspace characters and escape occurrences
  documentation = `ri #{arg}`
  cleaned_docs = documentation.gsub(/.\x08/, '') # Remove backspace characters
  cleaned_docs.gsub!("'s", "'\\\\\\'s") # Escape occurrences of 's
  cleaned_docs.gsub!("'t", "'\\\\\\'t") # Escape occurrences of 't

  # Pipe documentation to bat using ruby language highlighting
  system("echo \"#{cleaned_docs}\" | bat -l ruby")
end
