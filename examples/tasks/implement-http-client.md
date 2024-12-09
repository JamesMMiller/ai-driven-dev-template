# Implement HTTP Client for API Integration

## Overview
Create a type-safe HTTP client for interacting with an external API service, with proper error handling and retry mechanisms.

## Context
- System needs to communicate with external API service
- Requires robust error handling and retry logic
- Must handle rate limiting and timeouts
- Based on the GeminiHttpClient implementation example

## Requirements

### Functional Requirements
- [ ] Implement HTTP client with POST/GET methods
- [ ] Handle API responses and errors
- [ ] Support request retries
- [ ] Parse JSON responses to domain models
- [ ] Handle request timeouts

### Non-Functional Requirements
- [ ] Maximum response time: 30 seconds
- [ ] Retry failed requests up to 3 times
- [ ] Thread-safe implementation
- [ ] Resource cleanup on errors

## Acceptance Criteria
- [ ] Successfully sends requests to API
- [ ] Correctly handles API errors (400, 500 series)
- [ ] Retries on network failures
- [ ] Proper resource cleanup
- [ ] Comprehensive test coverage

## Technical Specifications

### Architecture
- HTTP Client component
- Error handling types
- Response models
- Configuration management

### Implementation Notes
```scala
trait ApiClient:
  def makeRequest(request: ApiRequest): IO[ApiError, ApiResponse]

case class HttpClient(config: Config, client: Client) extends ApiClient:
  def makeRequest(request: ApiRequest): IO[ApiError, ApiResponse] =
    for
      response <- sendRequest(request)
      result   <- handleResponse(response)
    yield result
```

### Testing Requirements
- Unit tests for error handling
- Integration tests with mock server
- Timeout and retry tests
- Error condition tests

## AI Development Guidelines

### Context for AI
```scala
// Example error handling
sealed trait ApiError
case class NetworkError(cause: Throwable) extends ApiError
case class ResponseError(code: Int, message: String) extends ApiError

// Example configuration
case class Config(
  apiKey: String,
  timeout: Duration,
  retryConfig: RetryConfig
)
```

### Quality Checklist
- [ ] Proper error type hierarchy
- [ ] Resource cleanup in scoped blocks
- [ ] Retry mechanism with backoff
- [ ] Timeout handling
- [ ] Request/response logging
- [ ] Test coverage > 80%

### Iterative Steps
1. Basic client implementation
2. Error handling and retries
3. Timeout and resource management
4. Testing and documentation

## Additional Notes
- Consider rate limiting
- Plan for circuit breaking
- Monitor performance metrics 