namespace :article do
  desc 'Create article'
  task :create do
    name = [(print "Article name: "), $stdin.gets.rstrip][1]
    description = [(print "Article description: "), $stdin.gets.rstrip][1]
    tags = [(print "Tags: "), $stdin.gets.rstrip][1]
    id = [(print "ID: "), $stdin.gets.rstrip][1].downcase.gsub %r{\W}, "-"
    if id[-1, 1] == "-"
      id[-1, 1] = ""
    end
    date = Time.new.strftime "%Y%m%d%H%M"
    path = File.join __dir__, "source/blog/#{id}.html.md"
    template = <<-MARKDOWN
---
title: #{name}
description: #{description}
date: #{date}
id: #{date}-#{id}
tags: #{tags}
---
MARKDOWN
    File.open path, 'w' do |f|
      f.write template
    end
    puts "Created #{path}"
  end
end