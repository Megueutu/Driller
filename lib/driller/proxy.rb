# frozen_string_literal: true

require "socket"
require "json"

module Driller
  class Proxy
    config = File.read("config.json")
    CHUNKS = JSON.parse(config)["chunk_size"]

    def initialize(listen_port:, upstream_host:, upstream_port:)
      @listen_port = listen_port
      @upstream_host = upstream_host
      @upstream_port = upstream_port
    end

    def start
      server = TCPServer.new(@listen_port)

      loop do
        client = server.accept
        Thread.new(client) { |c| handle(c) } # Divisão de thread única por client
      end
    ensure
      server&.close
    end

    private

    def handle(client)

      upstream = TCPSocket.new(@upstream_host, @upstream_port)
      done = Queue.new

      threads = [
        Thread.new { pipe(client, upstream); done << true },
        Thread.new { pipe(upstream, client); done << true }
      ]

      done.pop
      threads.each(&:kill)
    rescue SystemCallError => e
      warn "[driller] erro na conexão: #{e.message}"
    ensure
      client&.close
      upstream&.close
    end

    def pipe(from, to)
      loop do
        data = from.readpartial(CHUNK_SIZE) # levanta EOFError quando o outro lado fecha
        to.write(data)
      end
    rescue EOFError, IOError, SystemCallError
    end
  end
end
