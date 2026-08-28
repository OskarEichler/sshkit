module SSHKit

  module Runner

    class Sequential < Abstract
      attr_accessor :wait_interval

      def initialize(hosts, options = nil, &block)
        super(hosts, options, &block)
        @wait_interval = @options[:wait] || 2
      end

      def execute
        hosts.each_with_index do |host, index|
          run_backend(host, &block)
          sleep wait_interval unless index == hosts.length - 1
        end
      end

      private
      def run_backend(host, &block)
        backend(host, &block).run
      rescue ::StandardError => e
        e2 = ExecuteError.new e
        raise e2, "Exception while executing #{host.user ? "as #{host.user}@" : "on host "}#{host}: #{e.message}"
      end

    end

  end

end
