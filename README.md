# dedalus

* [Homepage](https://rubygems.org/gems/dedalus)
* [Documentation](http://rubydoc.info/gems/dedalus/frames)
* [Email](mailto:jweissman1986 at gmail.com)

[![Code Climate GPA](https://codeclimate.com/github//dedalus/badges/gpa.svg)](https://codeclimate.com/github//dedalus)

## Description

Atomic design pattern library for [Joyce](https://github.com/deepcerulean/joyce)

## Features

## Examples

    require 'joyce'
    require 'dedalus'

    class Image < Dedalus::Atom
      attr_accessor :image_file
    end

    class Heading < Dedalus::Atom
      attr_accessor :text
    end

    class Paragraph < Dedalus::Atom
      attr_accessor :text
    end

    class TextInput < Dedalus::Atom
      attr_accessor :placeholder
      attr_reader :text
    end

    class Button < Dedalus::Atom
      attr_accessor :text
    end
   
    class Tooltip < Dedalus::Atom
      attr_accessor :text
    end

    class Search < Dedalus::Molecule
      attr_accessor :placeholder

      def render(search_callback:)
        Heading.new(text: "Search")
        TextInput.new(placeholder: placeholder)
        Button.new(text: "Submit") do |button|
          button.on_click { search_callback.call(text) }
        end
      end
    end

    class PlayerNameList < Dedalus::Organism
      def render(player_details:, active_player_id:)
        player_details.each do |name:, joined_at:|
          Dedalus::Paragraph.new(text: name) do
            on_hover do
              Dedalus::Tooltip.new(text: joined_at, position: cursor)
            end
          end
        end
      end
    end

    class ApplicationTemplate < Dedalus::Template
      def render(player_details:, active_player_id:)

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
