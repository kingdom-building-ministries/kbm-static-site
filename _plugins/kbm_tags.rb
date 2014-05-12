module Jekyll
  class Site
      # Monkey patch the payload to include kbm tracked hash maps
      alias_method :orig_site_payload_kbm_tags, :site_payload
      def site_payload
        hash = orig_site_payload_kbm_tags
        siteHash = hash["site"]
        siteHash["bible_references"] = post_yaml_attr_hash("bible_references")
        siteHash["post_types"] = post_yaml_attr_hash("post_types")
        siteHash["series"] = post_yaml_attr_hash("series")
        siteHash["authors"] = post_yaml_attr_hash("author")
        siteHash["tags_alpha"] = siteHash["tags"].keys.sort
        hash["site"] = siteHash
        return hash
      end

      def post_yaml_attr_hash(post_attr)
        # Build a hash map based on the specified post attribute ( post attr =>
        # array of posts ) then sort each array in reverse order.
        hash = Hash.new { |hsh, key| hsh[key] = Array.new }
        self.posts.each do |p|
          attrib = p.data[post_attr]
          if !attrib.nil?
            if !attrib.kind_of?(Array)
              attrib = [attrib]
            end
            attrib.each { |t| hash[t] << p }
          end
        end
        hash.values.map { |sortme| sortme.sort! { |a, b| b <=> a } }
        hash
      end
  end
end
