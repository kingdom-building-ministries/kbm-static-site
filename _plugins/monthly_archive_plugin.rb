# Jekyll Module to create monthly archive pages
#
# Shigeya Suzuki, November 2013
# Copyright notice (MIT License) attached at the end of this file
#

#
# This code is based on the following works:
#   https://gist.github.com/ilkka/707909
#   https://gist.github.com/ilkka/707020
#   https://gist.github.com/nlindley/6409459
#

#
# Archive will be written as #{archive_path}/#{year}/#{month}/index.html
# archive_path can be configured in 'path' key in 'monthly_archive' of
# site configuration file. 'path' is default null.
#

module Jekyll
  class Site
      alias_method :orig_site_payload_month_archive, :site_payload
      def site_payload
        hash = orig_site_payload_month_archive
        hash["site"]["archive_urls"] = MonthlyArchiveGenerator.archived_urls(self)
        return hash
      end
  end

  # Generator class invoked from Jekyll
  class MonthlyArchiveGenerator < Generator
    def generate(site)
      self.class.posts_group_by_year_and_month(site).each do |ym, list|
        site.pages << MonthlyArchivePage.new(site, self.class.archive_base(site),
                                             ym[0], ym[1], list)
      end
    end

    def self.archived_urls(site)
      urls = Array.new
      posts_group_by_year_and_month(site).each do |ym, list|
        page = MonthlyArchivePage.new(site, archive_base(site), ym[0], ym[1], list)
        urls << { "date" => Date.new(ym[0], ym[1]), "url" => "/#{page.relative_path}" }
      end
      return urls
    end

    def self.posts_group_by_year_and_month(site)
      site.categories['blog'].each.group_by { |post| [post.date.year, post.date.month] }
    end

    def self.archive_base(site)
      site.config['monthly_archive'] && site.config['monthly_archive']['path'] || 'blog/archive/'
    end
  end

  # Actual page instances
  class MonthlyArchivePage < Page

    ATTRIBUTES_FOR_LIQUID = ATTRIBUTES_FOR_LIQUID + %w[
      year
      month
      date
    ]

    attr_accessor :year, :month, :date

    def initialize(site, dir, year, month, posts)
      @site = site
      @year = year
      @month = format('%02d', month.to_i).to_s
      @archive_dir_name = '%04d/%02d' % [year, month]
      @dir = File.join(dir, @archive_dir_name)
      @name = "index.html"
      @date = Date.new(year, month)
      @layout =  site.config['monthly_archive'] && site.config['monthly_archive']['layout'] || 'monthly_archive'
      self.ext = '.html'
      self.basename = 'index'
      self.data = {
          'layout' => @layout,
          'type' => 'archive',
          'title' => "Monthly archive #{@year}/#{@month}",
          'posts' => posts
      }
    end
  end
end

# The MIT License (MIT)
#
# Copyright (c) 2013 Shigeya Suzuki
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
