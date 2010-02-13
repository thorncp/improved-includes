# ImprovedIncludes
module ApplicationHelper
  
  @asset_dir = "public"
  
  def stylesheet_links(*sources)
    links, options = expand_sources_and_options("#{@asset_dir}/stylesheets", "css", sources)
    stylesheet_link_tag *links, options
  end
  
  def javascript_includes(*sources)
    links, options = expand_sources_and_options("#{@asset_dir}/javascripts", "js", sources)
    javascript_include_tag *links, options
  end
  
  private
  def expand_sources_and_options(root, filetype, sources)
    options = sources.extract_options!.stringify_keys
    recursive = options.delete("recursive")
    
    if sources.include? :all
      return sources, options
    end
    
    paths = []
    sources.each do |source|
      if source.is_a? Symbol
        paths << source
        next
      end
      
      if source.end_with? "/"
        tmp = recursive ? "**/" : ""
        Dir.glob("#{root}/#{source}#{tmp}*.#{filetype}").each do |path|
          paths << "#{path}".sub("#{root}/", '')
        end
      else
        paths << source
      end
    end
    return paths, options
  end
end
˝