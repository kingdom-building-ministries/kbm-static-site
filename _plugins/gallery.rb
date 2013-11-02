begin
  require 'exifr'
rescue LoadError
end

require 'webrick'
require 'RMagick'

module Jekyll

  class Site
      # Add a new array to contain all the items in the gallery
      #
      attr_accessor :photos

      alias orig_site_payload site_payload
      def site_payload
        hash = orig_site_payload
        siteHash = hash["site"]
        if self.photos
          siteHash["photos"] = self.photos.sort
        end
        hash["site"] = siteHash
        hash
      end
  end

  class Thumbnail < StaticFile

    def initialize(site, source, dir, name)
      @site = site
      @dir = dir
      @name = name
      @path = File.join(source, dir, "_photos", name)
    end

    def path
      return @path
    end

    def write(dest)
      target_path = destination(dest)

      return false if File.exist?(target_path) and !modified?
      @@mtimes[path] = mtime

      FileUtils.mkdir_p(File.dirname(target_path))
      img = Magick::ImageList.new(@path)
      thumb = img.resize_to_fill(75, 75)
      thumb.write(target_path)
      puts ("Thumbnail:" + target_path)
      true
    end

    def url
      WEBrick::HTTPUtils.escape_path(destination(''))
    end

    def destination(dest)
      rootImageDirectory = @site.config['photo_dest_dir'] || 'img'
      dest_string = File.join(dest, rootImageDirectory, @dir, @name)
      d = Pathname.new(dest_string)
      thumbName = d.basename(".*").to_s + "-th" + d.extname
      path = File.join(d.dirname, thumbName)
      path
    end
  end

  class Photo < StaticFile
    attr_accessor :name
    attr_accessor :image_url
    attr_accessor :albums
    attr_accessor :thumbnail

    def initialize(site, source, dir, name)
      @site = site
      @dir = dir
      @path = File.join(source, dir, "_photos", name)
      self.name = name
      self.image_url = WEBrick::HTTPUtils.escape_path(destination(''))

      self.thumbnail = Thumbnail.new(site, source, dir, name)

      self.albums = dir.downcase.split('/').reject { |x| x.empty? }
    end

    def to_liquid
      {
        "name" => self.name,
        "image_url" => self.image_url,
        "thumb_url" => self.thumbnail.url,
        "albums" => self.albums
      }
    end

    def path
      return @path
    end

    def destination(dest)
      rootImageDirectory = @site.config['photo_dest_dir'] || 'img'
      File.join(dest, rootImageDirectory, @dir, self.name)
    end

    def <=>(other)
      cmp = self.name <=> other.name
      return cmp
    end

    # Returns the object as a debug String.
    def inspect
      "#<Photo @name=#{self.name.inspect}>"
    end
  end

  class GalleryGenerator < Generator
  	safe true

  	def generate(site)
  	  site.photos = []
  		recursively_read_directories(site)
  	end

  	def recursively_read_directories(site, dir = '')
  	  base = File.join(site.source, dir)
  	  entries = Dir.chdir(base) { site.filter_entries(Dir.entries('.')) }

  	  read_photos(site, dir)
  	  site.photos.sort!

  	  entries.each do |f|
  	    f_abs = File.join(base, f)
  	    if File.directory?(f_abs)
  	      f_rel = File.join(dir, f)
  	      recursively_read_directories(site, f_rel) unless site.dest.sub(/\/$/, '') == f_abs
  	    end
  	  end
  	end

  	def read_photos(site, dir)
  	  entries = site.get_entries(dir, '_photos')
  	  entries.each do |f|
    		if f.downcase =~ /\.(?:png|jpe?g|bmp)$/
    		  photo = Photo.new(site, site.source, dir, f)
    		  site.photos << photo
    		  site.static_files << photo
    		  site.static_files << photo.thumbnail
    		end
  		end
  	end
  end
end
