# Contributing to Samwise

Thank you for your interest in contributing to Samwise! This document provides guidelines and information for contributors.

## Getting Started

### Prerequisites
- Xcode 14+ (for iOS development)
- Node.js 18+ (for backend development)
- MongoDB (for local development)
- Git

### Setting Up the Development Environment

1. **Clone the repository:**
   ```bash
   git clone https://github.com/seanreibeling/samwise-running-app.git
   cd samwise-running-app
   ```

2. **Backend Setup:**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   # Edit .env with your local configuration
   npm run dev
   ```

3. **iOS Setup:**
   ```bash
   open ios/Samwise.xcodeproj
   # Build and run in Xcode
   ```

## Development Workflow

### Branching Strategy
- `main` - Production-ready code
- `develop` - Integration branch for features
- `feature/description` - Feature branches
- `bugfix/description` - Bug fix branches

### Making Changes

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the code style guidelines below

3. **Test your changes:**
   - Run backend tests: `cd backend && npm test`
   - Test iOS app in simulator and device
   - Verify end-to-end functionality

4. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

5. **Push and create a pull request:**
   ```bash
   git push origin feature/your-feature-name
   ```

## Code Style Guidelines

### Swift/iOS
- Follow Swift API Design Guidelines
- Use SwiftUI best practices
- Maintain consistent naming conventions
- Add documentation comments for public APIs

### JavaScript/Node.js
- Use ES6+ features
- Follow Airbnb JavaScript Style Guide
- Use async/await over callbacks
- Add JSDoc comments for functions

### General
- Write descriptive commit messages
- Keep functions small and focused
- Add tests for new functionality
- Update documentation for API changes

## Pull Request Guidelines

### Before Submitting
- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] No breaking changes (or clearly documented)

### Pull Request Template
```
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] Tested on iOS device
- [ ] Tested end-to-end workflow

## Screenshots/Videos
(If applicable)
```

## Reporting Issues

### Bug Reports
Include:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Device/OS information
- Logs or error messages

### Feature Requests
Include:
- Use case description
- Proposed solution
- Alternative solutions considered
- Impact assessment

## Architecture Guidelines

### iOS App
- Follow MVVM architecture
- Use SwiftUI for UI components
- Separate business logic into services
- Use proper error handling

### Backend API
- RESTful endpoint design
- Proper HTTP status codes
- Input validation and sanitization
- Error handling middleware

## Security Guidelines

- Never commit sensitive data (API keys, passwords)
- Validate all user inputs
- Use HTTPS in production
- Follow OWASP security practices
- Implement proper authentication/authorization

## Community Guidelines

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Follow the code of conduct

## Questions?

- Open an issue for bugs or feature requests
- Start a discussion for questions
- Reach out to maintainers for guidance

Thank you for contributing to Samwise! 🏃‍♂️✨