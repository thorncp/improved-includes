# ImprovedIncludes
module ApplicationHelper  
  include ActionView::Helpers::AssetTagHelper
  
  def stylesheet_links(*sources)
    links, options = expand_sources_and_options(STYLESHEETS_DIR, "css", sources)
    stylesheet_link_tag links, options
  end
  
  def javascript_includes(*sources)
    links, options = expand_sources_and_options(JAVASCRIPTS_DIR, "js", sources)
    javascript_include_tag links, options
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
      if source =~ /\/$/
        tmp = recursive ? "**/" : ""
        Dir.glob("#{root}/#{source}#{tmp}*.#{filetype}").collect do |path|
          paths << "#{path}".sub("#{root}/", '')
        end
      else
        paths << source
      end
    end
    return paths, options
  end
end
