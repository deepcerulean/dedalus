# dedalus

* [Homepage](https://rubygems.org/gems/dedalus)
* [Documentation](http://rubydoc.info/gems/dedalus/frames)
* [Email](mailto:jweissman1986 at gmail.com)

[![Code Climate GPA](https://codeclimate.com/github//dedalus/badges/gpa.svg)](https://codeclimate.com/github//dedalus)

## Description

An incredible atomic design pattern library for [Joyce](https://github.com/deepcerulean/joyce)

## Features

  - Layout manager for Joyce apps

## Examples

    require 'dedalus'

    module PatternLibrary
      class ApplicationView < Joyce::ApplicationView
        def render
          composer.render!(welcome_screen)
        end

        private
        def welcome_screen
          @welcome_screen ||= WelcomeScreen.create
        end

        def composer
          @composer ||= Dedalus::ApplicationViewComposer.new(self)
        end
      end

      class ApplicationHeader < Dedalus::Organism
        attr_accessor :title, :subtitle

        def show
          [ heading, subheading ]
        end

        private
        def heading
          @heading ||= Elements::Heading.create(text: title)
        end

        def subheading
          @subheading ||= Elements::Heading.create(text: subtitle, scale: 0.75)
        end
      end

      class ApplicationSidebar < Dedalus::Organism
        has_many :library_sections

        def show
          self.library_sections.all
        end
      end

      class LibrarySection < Dedalus::Molecule
        belongs_to :application_sidebar
        attr_accessor :name

        def show
          Elements::Heading.create(text: name) 
        end

        def height
          0.03
        end
      end

      class ApplicationScreen < Dedalus::Template
        def layout
          [
            page_header, [ sidebar, yield ]
          ]
        end

        private
        def page_header
          @page_header ||= ApplicationHeader.create(
            title: 'Dedalus',
            subtitle: 'A Visual Pattern Library for Joyce',
            height: 0.1
          )
        end

        def sidebar
          @sidebar ||= ApplicationSidebar.create(
            library_sections: [
              LibrarySection.create(name: "Home"),
              LibrarySection.create(name: "Atoms"),
              LibrarySection.create(name: "Molecules"),
              LibrarySection.create(name: "Organisms"),
              LibrarySection.create(name: "Templates"),
              LibrarySection.create(name: "Screens")
            ],
            width: 0.3
          )
        end
      end

      class WelcomeScreen < ApplicationScreen
        def show
          layout { welcome_message }
        end

        def welcome_message
          @welcome_message ||= Elements::Heading.create(text: "Welcome to our Pattern Library!")
        end
      end

      class Application < Joyce::Application
        viewed_with ApplicationView
      end
    end

## Requirements

## Install

    $ gem install dedalus

## Synopsis

    $ dedalus

## Copyright

Copyright (c) 2016 Joseph Weissman

See {file:LICENSE.txt} for details.
