module KeywordFilterTags
  include Radiant::Taggable

  desc %{
<p>Process content only if the current page contains the keywords specified.</p>
<p> The attribute "all" controls if you want all of them or just one of keywords to match, by all of the keywords specifieds are required. </p>
<p> The attribute "case_sensitive" controls if you want matches to be case sensitive. True by default.</p>
*Usage*:
<pre><code><r:if_keyword filter="keyword1 keyword2" [all="false"] [case_sensitive="true"]> ... </r:if_keyword></code></pre>
  }
  tag "if_keyword" do |tag|
    if (isOk?(tag)) then
      tag.expand
    end
  end

  desc %{
<p>Process content only if the current page <em>does not</em> contains the keywords specified. This tag does the exact inverse of the if_keyword tag.</p>
<p> The attribute "all" controls if you want all of them or just one of keywords to match, by all of the keywords specifieds are required. </p>
<p> The attribute "case_sensitive" controls if you want matches to be case sensitive. True by default.</p>
*Usage*:
<pre><code><r:unless_keyword filter="keyword1 keyword2" [all="false"] [case_sensitive="true"]> ... </r:unless_keyword></code></pre>
  }
  tag "unless_keyword" do |tag|
    if (not isOk?(tag)) then
      tag.expand
    end
  end

  def isOk?(tag)
    all_attr            = tag.attr["all"]
    filter_attr         = tag.attr["filter"]
    case_attr = tag.attr["case_sensitive"]

    raise "`filter' attribute required" unless filter_attr

    all = (all_attr != "false" && all_attr != "no")
    case_sensitive = (case_attr != "false" && case_attr != "no") 

    keywords = tag.locals.page.keywords
    filters = tag.attr["filter"].split(/\s+/)

    unless case_sensitive
      keywords.downcase!
      filters.map!(&:downcase)
    end

    filters.each do |keyword|
      if (keywords.include?(keyword) != all) then
        return(not all)
      end
    end
    return all
  end
end
