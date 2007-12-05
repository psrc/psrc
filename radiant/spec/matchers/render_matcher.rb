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
            when @error_message: false
            when @expected: @actual == @expected
            when @matching: @actual =~ @matching
            else true
          end
        rescue => @error
          if @error_message
            @error.message === @error_message
          else
            @error_thrown = true
            false
          end
        end
        
        def failure_message
          action = @expected.nil? ? "render and match #{@matching.inspect}" : "render as #{@expected.inspect}"
          unless @error_thrown
            unless @error_message
              if @content
                "expected #{@content.inspect} to #{action}, but got #{@actual.inspect}"
              else
                "expected page to #{action}, but got #{@actual.inspect}"
              end
            else
              "expected rendering #{@content.inspect} to throw exception with message #{@error_message.inspect}, but was #{@error.message.inspect}"
            end
          else
            "expected #{@content.inspect} to render, but an exception was thrown #{e.inspect}"
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
        
        def with_error(message)
          @error_message = message
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
      
      # page.should render(input).as(output)
      # page.should render(input).matching(/hello world/)
      # page.should render(input).with_error(message)
      def render(input)
        RenderTags.new(input)
      end
      
      # page.should render_as(output)
      def render_as(output)
        RenderTags.new.as(output)
      end
      
    end
  end
end