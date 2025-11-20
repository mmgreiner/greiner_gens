module Greiner
  class SimplecssGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Add the simple.css framework and adjusts application.html.erb accordingly"

    def configure_simplecss
      style = 
        <<~STYLE.indent(4)

          <%= stylesheet_link_tag "https://cdn.simplecss.org/simple.min.css" %>
          <style>
            :root {
              --reading-width: min(45rem, 90%);
            }
            body {
              grid-template-columns: 0fr 98% 0fr;
            }
          </style>
        STYLE

      # add the additional stylesheet link
      inject_into_file 'app/views/layouts/application.html.erb', style, after: /^.+stylesheet_link_tag.+$/

      # replace the simple yield with header, navigation, main and footer
      gsub_file 'app/views/layouts/application.html.erb',
        '    <%= yield %>',
        <<~BODY.indent(4)
          <header>
            <nav>
              <ul>
                <li><%= link_to :home, root_path %>
              </ul>
            </nav>
          </header>
          <main>
            <%= yield %>
          </main>
          <footer>
            Copyright &copy; <my company>
          </footer>
        BODY
    end
  end
end