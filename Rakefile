require 'rubygems'
    require 'rake'
    require 'rdoc'
    require 'date'
    require 'yaml'
    require 'tmpdir'
    require 'jekyll'

    # desc "Generate blog files"
    # task :generate do
    #   Jekyll::Site.new(Jekyll.configuration({
    #     "source"      => ".",
    #     "destination" => "_site"
    #   })).process
    # end


    desc "Generate and publish blog to gh-pages"
    task :publish do
      Dir.mktmpdir do |tmp|
        system "mv dist/* #{tmp}"
        system "git checkout gh-pages"
        system "rm -rf *"
        system "mv #{tmp}/* ."
        message = "Site updated at #{Time.now.utc}"
        system "git add --all"
        system "git commit -am #{message.shellescape}"
        system "git push origin gh-pages --force"
        system "git checkout jekyll-docs"
        system "echo yolo"
      end
    end

task :default => :publish