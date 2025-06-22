module Greiner
  class SimpleCssGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Add the simple.css framework and adjusts application.html.erb accordingly"

    def configure_simpler
      inject_into_file 'app/views/layouts/application.html.erb',
        "\n" + '    <%= stylesheet_link_tag "https://cdn.simplecss.org/simple.min.css" %>', 
        after: '    <%= stylesheet_link_tag "application" %>'
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