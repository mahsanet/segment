# Segment Project Code of Conduct

## Our Pledge

We are committed to providing a welcoming, inclusive, and harassment-free environment for all
contributors, regardless of age, body size, visible or invisible disability, ethnicity, sex
characteristics, gender identity and expression, level of experience, education, socio-economic
status, nationality, personal appearance, race, religion, or sexual identity and orientation.

## Our Standards

### Positive Behavior

We encourage behaviors that contribute to a positive, collaborative environment:

- Demonstrating empathy and kindness toward other people
- Being respectful of differing opinions, viewpoints, and experiences
- Giving and gracefully accepting constructive feedback
- Accepting responsibility and apologizing to those affected by our mistakes
- Focusing on what is best not just for us as individuals, but for the overall project community

### Unacceptable Behavior

Behaviors that are unacceptable include:

- The use of sexualized language or imagery, and sexual attention or advances
- Trolling, insulting or derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without explicit permission
- Other conduct which could reasonably be considered inappropriate in a professional setting

## Project Structure and Architectural Integrity

### Directory Structure

Our project follows a **module-first/feature-first** approach:

```
segment/
│
├── lib/
│   ├── modules/
│   │   ├── authentication/
│   │   ├── home/
│   │   ├── profile/
│   │   └── ... (other feature modules)
│   │
│   └── shared/
│       ├── constants/
│       ├── extensions/
│       ├── services/
│       ├── theme/
│       ├── utils/
│       └── widgets/
│
└── ... (other project files)
```

#### Module Structure Guidelines

- Each module should be self-contained
- Modules represent distinct features or logical groupings
- Modules should have a consistent internal structure:
  ```
  module_name/
  ├── presentation/
  │   ├── screens/
  │   └── controllers/
  ├── domain/
  │   ├── models/
  │   └── repositories/
  ├── data/
  │   ├── datasources/
  │   └── repositories/
  └── application/
      └── services/
  ```

### Shared Functionality

#### Utility Helpers

We provide a set of shared utility functions to maintain consistency across the application:

- `showSnackBar()`: Display standard user notifications
- `showSnackBarOnError()`: Display error-specific notifications
- Other utility functions in `shared/utils/`

These helpers should be used instead of creating custom implementations to ensure:

- Consistent user experience
- Centralized error and notification handling
- Reduced code duplication

## Architectural Principles

### Code Architecture

1. **Layered Architecture**
   Our project follows a strict four-layer architecture:
    - Presentation Layer
    - Application Layer
    - Domain Layer
    - Data Layer

2. **Dependency Rules**
    - **Vertical Dependencies Only**:
        * Dependencies must flow strictly from top to bottom
        * No horizontal dependencies between components in the same or different layers
        * **Prohibited**: Direct calls from screens to repositories

    - **Layer Communication**:
        * Presentation Layer → Application Layer → Domain Layer ← Data Layer
        * Each layer can only communicate with the layer directly below it

3. **Presentation Layer Specifics**
    - **Controllers**:
        * Reside within the Presentation Layer
        * Responsible for managing widget states
        * Send states to screens and widgets
        * Handle asynchronous data mutations
        * Use AsyncNotifier for state management

4. **Immutability and Type Safety**:
    - Use immutable model classes in the Domain layer
    - Implement proper serialization methods (fromJson, toJson)
    - Override equality (==) and hashCode for model classes

5. **State Management**:
    - Utilize Riverpod providers effectively
    - Manage asynchronous state with AsyncNotifier
    - Handle UI states (data, loading, error) predictably

6. **Testability**:
    - Write code that is easily testable
    - Create mock dependencies when necessary
    - Ensure each layer can be tested in isolation

### Contribution Process

1. **Code Reviews**
    - All contributions must go through a thorough code review process
    - Reviews will check for:
        * Strict adherence to layered architecture
        * Correct dependency flow
        * Architectural compliance
        * Code quality
        * Performance considerations
        * Proper error handling
        * Consistent use of shared utilities

2. **Documentation**
    - Document all new features, classes, and complex logic
    - Update architecture documentation when significant changes are made
    - Maintain clear and concise comments
    - When adding new modules, update the project structure documentation

3. **Performance and Scalability**
    - Consider the performance implications of new code
    - Design features that allow independent work by team members
    - Avoid over-engineering while maintaining clean architecture
    - Leverage shared utilities and modules to reduce redundancy

## Reference Architecture Diagrams

### Full Application Architecture

![Full Application Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/images/flutter-app-architecture.webp)

### Data Layer Details

![Data Layer Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/images/data-layer-standalone.webp)

### Layer Interaction Example

![Layer Interaction Example](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/images/shopping-cart-layers.webp)

## Enforcement Responsibilities

Project maintainers are responsible for clarifying and enforcing our standards of acceptable
behavior and architectural guidelines. They will take appropriate and fair corrective action in
response to any violations.

### Reporting Issues

If you experience or witness unacceptable behavior or architectural inconsistencies, please report
it by contacting the project team. All complaints will be reviewed and investigated promptly and
fairly.

## Attribution

This Code of Conduct is adapted from the [Contributor Covenant][homepage], version 2.0, available
at https://www.contributor-covenant.org/version/2/0/code_of_conduct.html.

[homepage]: https://www.contributor-covenant.org

## Scope

This Code of Conduct applies within all community spaces, and also applies when an individual is
officially representing the community in public spaces.


---

**Last Updated**: [Current Date]