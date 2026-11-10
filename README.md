# Network Fault Injector

A lightweight, Ruby-based TCP fault injection tool designed to simulate controlled network failures and investigate how applications behave under degraded connectivity.

## Overview

Network Fault Injector (NFI) is an experimental networking tool that acts as an intermediary between TCP clients and servers, allowing developers to introduce artificial network conditions without modifying the applications themselves.

The project focuses on understanding TCP connections, stream forwarding, connection lifecycle management, and network fault simulation.

NFI is intended primarily for local development, networking experiments, and resilience testing in controlled environments.

## Motivation

Applications are frequently developed and tested under stable network conditions. However, real-world communication is subject to latency, bandwidth restrictions, unexpected disconnections, and temporary unavailability.

These conditions can expose problems that remain unnoticed during conventional testing, such as:

- Incorrect timeout handling.
- Unexpected connection termination.
- Inefficient reconnection behavior.
- Resource exhaustion caused by blocked connections.
- Failure to recover after network connectivity is restored.

NFI aims to make these situations reproducible, observable, and easier to investigate.

## How It Works

NFI operates as an explicit TCP proxy positioned between a client application and its target service.

```text
                Network Fault Injector
                       (Ruby)
                          |
                          v
+-------------+     +-------------+     +-------------+
|             |     |             |     |             |
| TCP Client  |---->|  TCP Proxy  |---->| TCP Server  |
|             |<----|             |<----|             |
+-------------+     +-------------+     +-------------+
                          |
                   Fault Injection
                          |
              +-----------+-----------+
              |           |           |
           Latency      Jitter     Bandwidth
                                    Limits
```

The proxy receives TCP connections, establishes communication with the configured destination, and forwards data in both directions.

During forwarding, configurable rules may modify the timing or availability of data transmission.

NFI operates on TCP byte streams. It does not aim to reproduce packet-level network behavior, such as actual IP packet loss or TCP segment reordering.

## Planned Capabilities

### TCP Proxy

Establish and manage bidirectional TCP communication between clients and upstream services.

Responsibilities include connection establishment, stream forwarding, buffering, resource management, and connection termination.

### Fault Injection

Introduce controlled communication conditions, including:

- **Latency:** Delay data forwarding.
- **Jitter:** Introduce variability in forwarding delays.
- **Bandwidth Limiting:** Restrict data transfer rates.
- **Connection Interruption:** Temporarily prevent data forwarding.
- **Connection Termination:** Force connections to close under controlled conditions.

Faults may be configured independently for each communication direction.

### Ruby DSL

Provide a Ruby-based Domain-Specific Language for defining proxy behavior, destinations, and fault injection rules.

The configuration should remain readable, expressive, and suitable for version control.

The DSL will describe how the proxy operates rather than requiring developers to implement networking behavior manually.

### Environment Configuration

Support environment-specific configurations, with external values supplied through environment variables.

This allows the same configuration to be reused across different development and testing environments without hardcoding machine-specific addresses.

### Local Observability

Record structured information about TCP connections and injected faults.

Planned information includes:

- Connection identifiers and timestamps.
- Connection establishment and termination events.
- Bytes forwarded in each direction.
- Applied fault configurations.
- Connection errors and termination reasons.
- Timing measurements.

SQLite is the proposed local persistence mechanism.

Application payload contents will not be stored by default.

## Project Scope

The initial scope is intentionally limited to keep the project focused on TCP networking fundamentals.

| In Scope | Out of Scope |
|---|---|
| TCP proxying | UDP proxying |
| Bidirectional stream forwarding | IP packet manipulation |
| Configurable transport faults | Full network emulation |
| Ruby-based configuration DSL | Web dashboard |
| Local connection tracing | Distributed orchestration |
| Local development and testing | Production traffic management |

NFI is not intended to replace operating-system networking tools, packet-level emulators, or established chaos engineering platforms.

Its primary purpose is to provide a focused environment for experimenting with TCP communication and understanding the effects of controlled failures.

## Technology

The project is planned around the following technologies:

| Technology | Purpose |
|---|---|
| Ruby | Core implementation |
| Ruby Standard Library | TCP sockets and I/O operations |
| RubyGems | Library packaging and distribution |
| Bundler | Dependency management |
| Minitest | Automated testing |
| SQLite | Local event persistence |

The implementation will prioritize Ruby's native capabilities and avoid unnecessary frameworks.

## Development Status

**Status: Planning / Early Development**

The architecture, configuration syntax, and initial feature boundaries are still being defined.

The project is being developed as a practical exploration of Ruby, TCP networking, and fault injection techniques.

Features described in this document represent the intended scope and are not necessarily implemented.

## License

To be defined.