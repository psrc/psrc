module Spec
  module Rails
    module Matchers
      
      class RenderTags
        def initialize(content = nil)
          @content = content
        end
        
        def matches?(page)
          @actual = render_content_with_page(@content, page)
          if @expected.kind_of?(Regexp)
            @expected = nil
            @matching = @expected
          end
          case
          when @expected
            @actual == @expected
          when @matching
            @actual =~ @matching
          else
            true
          end
        end
        
        def failure_message
          if @content
            "expected #{@content.inspect} to render as #{@expected.inspect}, but got #{@actual.inspect}"
          else
            "expected page to render as #{@expected.inspect}, but got #{@actual.inspect}"
          end
        end
        
        def description
          "render tags #{@expected.inspect}"
        end
        
        def as(output)
          @expected = output
          self
        end
        
        def matching(regexp)
          @matching = regexp
          self
        end
        
        private
          def render_content_with_page(tag_content, page)
            page.request = ActionController::TestRequest.new
            page.request.request_uri = page.url
            page.request.host = "testhost.tld"
            page.response = ActionController::TestResponse.new
            if tag_content.nil?
              page.render
            else
              page.send(:parse, tag_content)
            end
          end
      end
      
      # page.should render.as(output)
      # page.should render(input).as(output)
      # page.should render(input).matching(/hello world/)
      # page.should render(input).with_error(message)
      def render(input)
        RenderTags.new(input)
      end
      
    end
  end
end