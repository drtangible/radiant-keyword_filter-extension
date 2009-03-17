module KeywordFilterTags
	include Radiant::Taggable

	desc %{
Search for all pages that have a certain keyword tag.
*Usage*:
<pre><code><r:if_keyword filter="keyword1 keyword2"> ... </r:if_keyword></code></pre>
	}
	tag "if_keyword" do |tag|
		if (isOk?(tag)) then
			tag.expand
		end
	end

	desc %{
<p>Process content only if the current page <em>does not</em> contains the keywords specified. This tag does the exact inverse of the if_keyword tag.</p>
*Usage*:
<pre><code><r:unless_keyword filter="keyword1 keyword2"> ... </r:unless_keyword></code></pre>
	}
	tag "unless_keyword" do |tag|
		if (not isOk?(tag)) then
			tag.expand
		end
	end

	def isOk?(tag)
		raise "`filter' attribute required" unless tag.attr["filter"]

		result = false
		tag.attr["filter"].split(/\s+/).each do |keyword|
			print "testing : #{keyword} on '#{tag.locals.page.keywords}'\n"
			if (tag.locals.page.keywords.include?(keyword)) then
				return true
			end
		end
		return false
	end
end
