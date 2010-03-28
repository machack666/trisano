module HtmlunitRat
  module Selenium
    class Adapter
      WebClient = Java::ComGargoylesoftwareHtmlunit::WebClient
      WebAssert = Java::ComGargoylesoftwareHtmlunit::WebAssert

      def initialize(base="http://localhost:8080")
        @base_url = base
        @web_client = WebClient.new
      end

      def open(path)
        @web_client.get_page(url(path))
      end

      def response
        current_page.web_response
      end

      # does nothing, but needed for compatibility
      def wait_for_page_to_load(duration)
      end

      # grr, type is masked. going hacky
      def type(field_id, value)
        element = element_by_id(field_id)
        value.to_java_string.to_char_array.each do |c|
          element.doType(c, false, false, false)
        end
      end

      def click(matcher)
        element(matcher).click
      end

      def select(matcher, option)
        element = element(matcher)
        if option =~ /^label=(.*)$/i
          element.get_option_by_text($1).setSelected(true)
        end
      end

      # tests and matchers

      def is_text_present(text)
        response.content_as_string.index(text) != nil
      end

      def is_element_present(matcher)
        element(matcher) != nil
      end

      # our uat's expect all attributes to be double quoted
      def get_html_source
        response.content_as_string.gsub("'", '"')
      end

      def get_by_xpath(xpath)
        current_page.get_by_xpath(xpath)
      end

      def get_value(matcher)
        element(matcher).get_value_attribute
      end

      def current_page
        @web_client.get_current_window.get_enclosed_page
      end

      def url(path)
        File.join(@base_url, path)
      end

      def anchor_by_text(text)
        begin
          current_page.get_anchor_by_text(text)
        rescue
          return nil
        end
      end

      def element_by_id(id)
        current_page.get_element_by_id(id)
      end

      def element_by_xpath(xpath)
        current_page.get_first_by_xpath(xpath)
      end

      def element(matcher)
        if (matcher =~ /^link=(.*)$/i)
          element = anchor_by_text($1)
        elsif (matcher =~ /^id=(.*)$/i)
          element = element_by_id($1)
        else
          element = element_by_id(matcher)
          unless element
            element = element_by_xpath(matcher)
          end
        end
        element
      end

    end

  end
end
