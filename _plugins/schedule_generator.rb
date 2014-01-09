module Jekyll

  class SchedulePage < Page
    def initialize(site, base, dir, speaker)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'speaker-schedule.html')
      self.data['speaker'] = speaker
      self.data['title'] = "Speaker Schedule: #{speaker['name']}"
    end
  end

  class SchedulePageGenerator < Generator
    safe true

    def generate(site)
      if !site.layouts.key? 'speaker-schedule'
        puts 'no speaker template found'
        return
      end
      dir = 'speakers/schedule'
      site.data['speakers'].each do |speaker|
        site.pages << SchedulePage.new(site, site.source, File.join(dir, speaker['value']), speaker)
      end
    end
  end

end
