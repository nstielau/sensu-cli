require 'rainbow'

module SensuCli
  class Pretty

    def self.print(res)
      if !res.empty?
        if res.is_a?(Hash)
          res.each do |key,value|
            puts "#{key}:  ".color(:cyan) + "#{value}".color(:green)
          end
        elsif res.is_a?(Array)
          res.each do |item|
            puts "-------".color(:yellow)
            if item.is_a?(Hash)
              item.each do |key,value|
                puts "#{key}:  ".color(:cyan) + "#{value}".color(:green)
              end
            else
              puts item.to_s.color(:cyan)
            end
          end
        end
      else
        puts "no values for this request".color(:cyan)
      end
    end

    def self.table(res)
      if !res.empty?
        if res.is_a?(Hash)
          res.each do |key,value|
            puts "#{key}:".color(:cyan) + "#{value}".color(:green)
          end
        elsif res.is_a?(Array)
          keys = res.map{|item| item.keys}.flatten.uniq.sort

          # Remove fields with spaces (breaks awkage)
          keys.select! do |key|
            res.none?{|item| item[key].to_s.include?(' ')}
          end

          # Find max value lengths
          value_lengths = {}
          keys.each do |key|
            max_value_length = res.map{|item| item[key].to_s.length}.max
            value_lengths[key] = [max_value_length, key.length].max
          end

          # Print header
          format = keys.map {|key| "%-#{value_lengths[key]}s"}.join(' ')
          puts sprintf(format, *keys)

          # Print value rows
          res.each do |item|
            if item.is_a?(Hash)
              values = keys.map {|key| item[key]}
              format = keys.map {|key| "%-#{value_lengths[key]}s"}.join(' ')
              puts sprintf(format, *values)
            else
              puts item.to_s.color(:cyan)
            end
          end
        end
      else
        puts "no values for this request".color(:cyan)
      end
    end

    def self.count(res)
      res.is_a?(Hash) ? count = res.length : count = res.count
      puts "#{count} total items".color(:yellow) if count
    end

  end
end
