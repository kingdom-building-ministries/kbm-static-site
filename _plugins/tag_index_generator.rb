module Jekyll

  class IndexPage < Page
    def initialize(site, base, dir, category, layout)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), layout+".html")
      self.data['category'] = category
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      @site = site
      @payload = site.site_payload

      attributes = [ { :attr =>"post_types", :url_prefix => 'post_type'},
         { :attr =>"tags", :url_prefix => 'topic'},
         { :attr =>"series", :url_prefix => 'series'},
         { :attr =>"bible_references", :url_prefix => 'post_type'},
         { :attr =>"authors", :url_prefix => 'author'}]
      attributes.each do |an_attribute|
        layout_name = "#{an_attribute[:attr]}_index"
        if !site.layouts.key? layout_name
          puts "No #{layout_name} index layout found"
          next
        end
        create_attribute_index(an_attribute, layout_name)
      end
    end

    def create_attribute_index(page_info, layout_name)
      puts "evaluating #{page_info[:attr]}"
      if @payload['site'][page_info[:attr]].nil?
        return
      end

      dir = "blog/" + page_info[:url_prefix]
      @payload['site'][page_info[:attr]].each do |category_array|
        title = category_array[0];
        category = sanitize_category_name(title)
        puts "key:#{category}"
        page = IndexPage.new(@site, @site.source, File.join(dir, category), category, layout_name)
        page.data['tagged_posts'] = category_array[1]
        puts "posts"
        puts page.data['tagged_posts'].inspect
        page.data['title'] = "#{title}"
        @site.pages << page
      end
    end

    def sanitize_category_name(name)
      new_name = name.strip
      new_name.sub! ' ', '-'
      new_name.sub! "\'", ''
      new_name.sub! "\"", ''
      new_name.downcase!
      new_name
    end

  end

end
