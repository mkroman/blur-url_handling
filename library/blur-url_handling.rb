# encoding: utf-8

require 'blur'

module Blur
  module URLHandling
    class URLHandler
      def initialize
        @index = -1
        @handlers = { hosts: {} }
      end

      def register *args, &block
        @index += 1

        args.each do |arg|
          case arg
          when String
            register_handler host: arg, &block
          when Hash
            register_handler arg, &block
          end
        end

        @index
      end

      # Registers the criteria for the handler and returns a unique method id.
      def register_handler criteria, &block
        if host = criteria[:host]
          (@handlers[:hosts][host] ||= []) << @index

          @index
        end
      end

      def handler_method_ids_for url
        @handlers[:hosts][url.host]
      end
    end

    module ClassMethods
      def url_handler; class_variable_get :@@url_handler end
      def url_handler= handler; class_variable_set :@@url_handler, handler end

      def register_url! *args, &block
        id = url_handler.register *args
        define_method :"_url_handler_#{id}", &block
      end
    end

    def self.included klass
      klass.extend ClassMethods
      klass.url_handler = URLHandler.new
      klass.register! message: -> (script, user, channel, line, _tags) {
        return unless urls = URI.extract(line, %w[http https])

        urls.each do |url|
          url = URI.parse url
          method_ids = klass.url_handler.handler_method_ids_for url

          if method_ids and method_ids.any?
            method_ids.each do |id|
              script.__send__ :"_url_handler_#{id}", user, channel, url
            end
          end
        end
      }
    end
  end
end

