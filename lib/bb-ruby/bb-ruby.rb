#overwrite process_tags method, because original one doesn't work with nested tags(like citation)'
# also mark returned string as html_safe
module BBRuby
  class << self

    def process_tags(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      text = text.dup

      # escape "<, >, &" to remove any html
      if escape_html
        text.gsub!('&', '&amp;')
        text.gsub!('<', '&lt;')
        text.gsub!('>', '&gt;')
      end

      tags_definition = @@tags.merge(tags_alternative_definition)

      # parse bbcode tags
      case method
        when :enable
          tags_definition.each_value do |t|
            if tags.include?(t[4])
              while text.gsub!(t[0], t[1]) do
                #nothing
              end
            end
          end
        when :disable
          # this works nicely because the default is disable and the default set of tags is [] (so none disabled) :)
          tags_definition.each_value do |t|
            unless tags.include?(t[4])
              while text.gsub!(t[0], t[1]) do
                #nothing
              end
            end
          end
      end

      text
    end

    def to_html_with_html_safe(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      text = to_html_without_html_safe(text, tags_alternative_definition, escape_html, method, *tags)
      text.respond_to?(:html_safe) ? text.html_safe : text
    end

    alias_method_chain :to_html, :html_safe

    def to_html_with_formatting_with_html_safe(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      text = to_html_with_formatting_without_html_safe(text, tags_alternative_definition, escape_html, method, *tags)
      text.respond_to?(:html_safe) ? text.html_safe : text
    end

    alias_method_chain :to_html_with_formatting, :html_safe

  end
end