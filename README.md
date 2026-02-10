# GreinerGens

These are two generators that simplify my rails life. They
- insert the necessary stylesheets and adopt the `application.html.erb` for [simplecss].
- add the [slim][slim-rails] template and set the templating engine in `config/application.rb`.



## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add greiner_gens --github mmgreiner/greiner_gens
```


## Usage

- generate your rails application as usual with `rails new my-app`
- change into the rails app `cd my-app`
- add the gem with `bundle add greiner_gens --github mmgreiner/greiner_gens`

~~~bash
% bin/rails generate --help
Usage:
  bin/rails generate GENERATOR [args] [options]

General options:
  ...

Please choose a generator below.

Rails:
  application_record
  ...

Greiner:
  greiner:simple_css
  greiner:slim

Slim:
  slim:authentication
...
~~~

### Use Slim

~~~bash
bin/rails generate greiner:slim
     gemfile  slim-rails
         run  bundle install from "."
Bundle complete! 18 Gemfile dependencies, 119 gems now installed.
      insert  config/application.rb
~~~

### Use [simplecss]

~~~bash
bin/rails g greiner:simplecss
      insert  app/views/layouts/application.html.erb
        gsub  app/views/layouts/application.html.erb
~~~

There is an option which changes the color scheme for night to the colors of the Kanton Luzern, and adds
the logo of the Kanton Luzern, according to the [Corporate Design des Kantons Luzern](https://intranet.lu.ch/corporate/staatskanzlei/SitePages/Corporate-Design.aspx) (available only after login).

~~~bash
bin/rails g greiner:simplecss --luzern
~~~


## Development

### developing generators and templates

It took me some time to understand the concept. Help is available in the [tutorial](https://guides.rubyonrails.org/generators.html#first-contact). In particular, I was fighting with how to get it running in rails. 
There are two tasks: code the generators and creating a gem.

#### Develop the generator

Create a dummy rails app and develop the generator in there.

~~~bash
% rails new qw-app --minimal
% cd qw-app
% rails g generator my-gen  
      create  lib/generators/my_gen
      create  lib/generators/my_gen/my_gen_generator.rb
      create  lib/generators/my_gen/USAGE
      create  lib/generators/my_gen/templates
      invoke  test_unit
      create    test/lib/generators/my_gen_generator_test.rb
% tree lib/generators
lib/generators
└── my_gen
    ├── USAGE
    ├── my_gen_generator.rb
    └── templates
~~~

You start coding in `my_gen_generator.rb` as shown in the [turorial](https://guides.rubyonrails.org/generators.html#creating-generators-with-generators).

#### Write the gem

Now I had to package this into a gem.

~~~bash
% bundle gem greiner_gens
% cd greiner_gens
% tree 
.
├── Gemfile
├── README.md
├── Rakefile
├── bin
│   ├── console
│   └── setup
├── lib
│   ├── greiner_gens
│   │   └── version.rb
│   └── greiner_gens.rb
├── greiner_gens.gemspec
└── sig
    └── greiner_gens.rbs
~~~

The trick here is that we have to tie it into `railstie`. To do this, add the file `railtie.rb` next to `version.rb`:

~~~ruby
require 'rails/railtie'

module GreinerGens
  class Railtie < Rails::Railtie
    generators do
      require 'generators/greiner/slim/slim_generator'
      require 'generators/greiner/simple_css/simple_css_generator'
    end
  end
end
~~~

Railtie also has to be called from `lib/greiner_gens.rb`:

~~~ruby {highlight=[2]}
require_relative "greiner_gens/version"
require_relative "greiner_gens/railtie" if defined?(Rails)

module GreinerGens
  class Error < StandardError; end
  # Your code goes here...
end

~~~

Note that we are using the module structure, which will give you two ruby generators called `greiner:slim` and `greiner:simplecss`. This results in the final folder structure:

~~~~
.
├── Gemfile
├── Gemfile.lock
├── README.md
├── Rakefile
├── bin
│   ├── console
│   └── setup
├── greiner_gens-0.1.0.gem
├── greiner_gens.gemspec
├── lib
│   ├── generators
│   │   └── greiner
│   │       ├── simplecss
│   │       │   └── simplecss_generator.rb
│   │       └── slim
│   │           └── slim_generator.rb
│   ├── greiner_gens
│   │   ├── railtie.rb
│   │   └── version.rb
│   └── greiner_gens.rb
└── sig
    └── greiner_gens.rbs
~~~~


Make sure that all these new files are also in your `git`, since the `gemspec` file uses `git ls-files` the package the files into the gem package.

Proceed with:

~~~bash
% gem build *gemspec
% gem install *gem
~~~

If you are unsure where this is installed locally, check:

~~~bash
% gem env path
% gem list | my-gem
% gem info my-gem
...
~~~

you should find your gem there.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmgreiner/greiner_gens.


[simplecss]: https://simplecss.org/
[slim-rails]: https://github.com/slim-template/slim-rails/tree/master

