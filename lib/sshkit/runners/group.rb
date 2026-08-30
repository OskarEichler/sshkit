module SSHKit

  module Runner

    class Group < Sequential
      attr_accessor :group_size

      def initialize(hosts, options = nil, &block)
        super(hosts, options, &block)
        @group_size = @options[:limit] || 2
      end

      def execute
        groups = hosts.each_slice(group_size).to_a
        groups.each_with_index.collect do |group_hosts, index|
          Parallel.new(group_hosts, &block).execute
          sleep wait_interval unless index == groups.length - 1
        end.flatten
      end

    end

  end

end
