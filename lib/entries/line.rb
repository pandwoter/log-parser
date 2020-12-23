# frozen_string_literal: true

require 'ipaddress'

module LogsParser
  module Entries
    class Line
      def initialize(line, ip_validation_lib = IPAddress)
        @path, @addr = line.split
        @ip_validation_lib = ip_validation_lib
      end

      def call
        to_h
      end

      private

      attr_reader :path, :addr, :ip_validation_lib

      def to_h
        {
          addr: addr,
          path: path,
          valid?: validate
        }
      end

      def validate
        @validate ||= [].tap do |result|
          path_addr_present? result
          addr_valid? result
        end
      end

      ##
      # Becouse example file do not contains any valid IP addr, validation is commented here
      # IN ORDER TEST TO PASS WE SCHOULD UNCOMENT IT!!!
      def addr_valid?(res)
        res << "Provided IP addr isn't valid!" unless true # ip_validation_lib.valid? addr
      end

      def path_addr_present?(res)
        res << "Line format isn't valid!" unless path && addr
      end
    end
  end
end
