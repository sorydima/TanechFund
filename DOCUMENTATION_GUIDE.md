# Documentation Guide - REChain VC Lab

## 📚 Documentation Overview

This document outlines our comprehensive documentation strategy for REChain VC Lab, covering technical documentation, user guides, API documentation, and knowledge management.

## 🎯 Documentation Principles

### Core Principles

#### 1. Clarity
- **Clear Language**: Use simple, clear language
- **Consistent Style**: Maintain consistent writing style
- **Logical Structure**: Organize information logically
- **Visual Hierarchy**: Use proper headings and formatting

#### 2. Completeness
- **Comprehensive Coverage**: Cover all aspects of the system
- **Up-to-Date**: Keep documentation current
- **Accurate Information**: Ensure information is accurate
- **Complete Examples**: Provide complete, working examples

#### 3. Accessibility
- **Easy to Find**: Make documentation easy to discover
- **Searchable**: Enable search functionality
- **Cross-Referenced**: Link related documentation
- **Multiple Formats**: Provide various formats

#### 4. Maintenance
- **Regular Updates**: Update documentation regularly
- **Version Control**: Track documentation changes
- **Review Process**: Regular documentation reviews
- **Feedback Loop**: Collect and incorporate feedback

## 📖 Documentation Types

### 1. Technical Documentation

#### API Documentation
```typescript
/**
 * User Service API
 * 
 * Provides user management functionality including CRUD operations,
 * authentication, and user profile management.
 * 
 * @example
 * ```typescript
 * const userService = new UserService();
 * const user = await userService.getUserById('123');
 * ```
 */
export class UserService {
  /**
   * Retrieves a user by their unique identifier.
   * 
   * @param id - The unique identifier of the user
   * @returns Promise that resolves to the user object or null if not found
   * @throws {ValidationError} When the provided ID is invalid
   * @throws {NotFoundError} When the user is not found
   * 
   * @example
   * ```typescript
   * try {
   *   const user = await userService.getUserById('123');
   *   if (user) {
   *     console.log(`User found: ${user.name}`);
   *   }
   * } catch (error) {
   *   console.error('Error fetching user:', error.message);
   * }
   * ```
   */
  async getUserById(id: string): Promise<User | null> {
    if (!id || id.trim() === '') {
      throw new ValidationError('User ID is required');
    }
    
    try {
      return await this.userRepository.findById(id);
    } catch (error) {
      throw new NotFoundError(`User with ID ${id} not found`);
    }
  }
  
  /**
   * Creates a new user with the provided data.
   * 
   * @param userData - The user data to create
   * @returns Promise that resolves to the created user object
   * @throws {ValidationError} When the provided data is invalid
   * @throws {ConflictError} When a user with the same email already exists
   * 
   * @example
   * ```typescript
   * const userData = {
   *   name: 'John Doe',
   *   email: 'john@example.com'
   * };
   * 
   * try {
   *   const user = await userService.createUser(userData);
   *   console.log(`User created with ID: ${user.id}`);
   * } catch (error) {
   *   console.error('Error creating user:', error.message);
   * }
   * ```
   */
  async createUser(userData: CreateUserData): Promise<User> {
    // Validate input data
    this.validateUserData(userData);
    
    // Check if user already exists
    const existingUser = await this.userRepository.findByEmail(userData.email);
    if (existingUser) {
      throw new ConflictError('User with this email already exists');
    }
    
    // Create user
    const user = new User({
      ...userData,
      id: this.generateId(),
      createdAt: new Date(),
      isActive: true,
    });
    
    return await this.userRepository.save(user);
  }
  
  /**
   * Updates an existing user with the provided data.
   * 
   * @param id - The unique identifier of the user to update
   * @param updateData - The data to update
   * @returns Promise that resolves to the updated user object
   * @throws {ValidationError} When the provided data is invalid
   * @throws {NotFoundError} When the user is not found
   * 
   * @example
   * ```typescript
   * const updateData = {
   *   name: 'Jane Doe',
   *   email: 'jane@example.com'
   * };
   * 
   * try {
   *   const user = await userService.updateUser('123', updateData);
   *   console.log(`User updated: ${user.name}`);
   * } catch (error) {
   *   console.error('Error updating user:', error.message);
   * }
   * ```
   */
  async updateUser(id: string, updateData: UpdateUserData): Promise<User> {
    if (!id || id.trim() === '') {
      throw new ValidationError('User ID is required');
    }
    
    // Validate update data
    this.validateUpdateData(updateData);
    
    // Find existing user
    const existingUser = await this.userRepository.findById(id);
    if (!existingUser) {
      throw new NotFoundError(`User with ID ${id} not found`);
    }
    
    // Update user
    const updatedUser = { ...existingUser, ...updateData };
    return await this.userRepository.save(updatedUser);
  }
  
  /**
   * Deletes a user by their unique identifier.
   * 
   * @param id - The unique identifier of the user to delete
   * @returns Promise that resolves when the user is deleted
   * @throws {ValidationError} When the provided ID is invalid
   * @throws {NotFoundError} When the user is not found
   * 
   * @example
   * ```typescript
   * try {
   *   await userService.deleteUser('123');
   *   console.log('User deleted successfully');
   * } catch (error) {
   *   console.error('Error deleting user:', error.message);
   * }
   * ```
   */
  async deleteUser(id: string): Promise<void> {
    if (!id || id.trim() === '') {
      throw new ValidationError('User ID is required');
    }
    
    // Check if user exists
    const existingUser = await this.userRepository.findById(id);
    if (!existingUser) {
      throw new NotFoundError(`User with ID ${id} not found`);
    }
    
    // Delete user
    await this.userRepository.delete(id);
  }
  
  /**
   * Validates user data for creation.
   * 
   * @param userData - The user data to validate
   * @throws {ValidationError} When the data is invalid
   * @private
   */
  private validateUserData(userData: CreateUserData): void {
    if (!userData.name || userData.name.trim() === '') {
      throw new ValidationError('Name is required');
    }
    
    if (!userData.email || userData.email.trim() === '') {
      throw new ValidationError('Email is required');
    }
    
    if (!this.isValidEmail(userData.email)) {
      throw new ValidationError('Invalid email format');
    }
  }
  
  /**
   * Validates update data.
   * 
   * @param updateData - The update data to validate
   * @throws {ValidationError} When the data is invalid
   * @private
   */
  private validateUpdateData(updateData: UpdateUserData): void {
    if (updateData.email && !this.isValidEmail(updateData.email)) {
      throw new ValidationError('Invalid email format');
    }
  }
  
  /**
   * Validates email format.
   * 
   * @param email - The email to validate
   * @returns True if the email is valid, false otherwise
   * @private
   */
  private isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }
  
  /**
   * Generates a unique identifier.
   * 
   * @returns A unique identifier string
   * @private
   */
  private generateId(): string {
    return Math.random().toString(36).substr(2, 9);
  }
}
```

#### Database Schema Documentation
```sql
-- Users Table
-- Stores user information and authentication data
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,                    -- Unique user identifier
    name VARCHAR(255) NOT NULL,                    -- User's full name
    email VARCHAR(255) UNIQUE NOT NULL,            -- User's email address
    password_hash VARCHAR(255) NOT NULL,           -- Hashed password
    is_active BOOLEAN DEFAULT TRUE,                -- User account status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Account creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update time
    last_login TIMESTAMP NULL,                     -- Last login time
    email_verified BOOLEAN DEFAULT FALSE,          -- Email verification status
    mfa_enabled BOOLEAN DEFAULT FALSE,             -- Multi-factor authentication status
    mfa_secret VARCHAR(255) NULL,                  -- MFA secret key
    profile_image_url VARCHAR(500) NULL,           -- Profile image URL
    timezone VARCHAR(50) DEFAULT 'UTC',            -- User's timezone
    language VARCHAR(10) DEFAULT 'en',             -- User's preferred language
    theme VARCHAR(20) DEFAULT 'light'              -- User's preferred theme
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_is_active ON users(is_active);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Blockchains Table
-- Stores blockchain network information
CREATE TABLE blockchains (
    id VARCHAR(50) PRIMARY KEY,                    -- Blockchain identifier (e.g., 'eth', 'btc')
    name VARCHAR(255) NOT NULL,                    -- Blockchain name
    symbol VARCHAR(10) NOT NULL,                   -- Blockchain symbol
    type ENUM('mainnet', 'testnet', 'devnet') NOT NULL, -- Network type
    rpc_url VARCHAR(500) NOT NULL,                 -- RPC endpoint URL
    explorer_url VARCHAR(500) NULL,                -- Block explorer URL
    is_active BOOLEAN DEFAULT TRUE,                -- Blockchain status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update time
    chain_id INTEGER NULL,                         -- Chain ID
    native_currency VARCHAR(50) NULL,              -- Native currency symbol
    block_time INTEGER NULL,                       -- Average block time in seconds
    gas_limit BIGINT NULL,                         -- Gas limit
    min_gas_price BIGINT NULL,                     -- Minimum gas price
    max_gas_price BIGINT NULL,                     -- Maximum gas price
    priority INTEGER DEFAULT 0                     -- Display priority
);

-- Indexes for performance
CREATE INDEX idx_blockchains_type ON blockchains(type);
CREATE INDEX idx_blockchains_is_active ON blockchains(is_active);
CREATE INDEX idx_blockchains_priority ON blockchains(priority);

-- User Blockchains Table
-- Links users to their supported blockchains
CREATE TABLE user_blockchains (
    id VARCHAR(36) PRIMARY KEY,                    -- Unique identifier
    user_id VARCHAR(36) NOT NULL,                  -- User ID
    blockchain_id VARCHAR(50) NOT NULL,            -- Blockchain ID
    wallet_address VARCHAR(255) NULL,              -- User's wallet address
    is_primary BOOLEAN DEFAULT FALSE,              -- Primary blockchain flag
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update time
    
    -- Foreign key constraints
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (blockchain_id) REFERENCES blockchains(id) ON DELETE CASCADE,
    
    -- Unique constraint
    UNIQUE KEY unique_user_blockchain (user_id, blockchain_id)
);

-- Indexes for performance
CREATE INDEX idx_user_blockchains_user_id ON user_blockchains(user_id);
CREATE INDEX idx_user_blockchains_blockchain_id ON user_blockchains(blockchain_id);
CREATE INDEX idx_user_blockchains_is_primary ON user_blockchains(is_primary);

-- Transactions Table
-- Stores blockchain transaction information
CREATE TABLE transactions (
    id VARCHAR(36) PRIMARY KEY,                    -- Unique transaction identifier
    user_id VARCHAR(36) NOT NULL,                  -- User ID
    blockchain_id VARCHAR(50) NOT NULL,            -- Blockchain ID
    tx_hash VARCHAR(255) UNIQUE NOT NULL,          -- Transaction hash
    from_address VARCHAR(255) NOT NULL,            -- Sender address
    to_address VARCHAR(255) NOT NULL,              -- Recipient address
    amount DECIMAL(36, 18) NOT NULL,               -- Transaction amount
    currency VARCHAR(10) NOT NULL,                 -- Currency symbol
    gas_used BIGINT NULL,                          -- Gas used
    gas_price BIGINT NULL,                         -- Gas price
    status ENUM('pending', 'confirmed', 'failed') DEFAULT 'pending', -- Transaction status
    block_number BIGINT NULL,                      -- Block number
    block_hash VARCHAR(255) NULL,                  -- Block hash
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update time
    confirmation_count INTEGER DEFAULT 0,          -- Number of confirmations
    fee DECIMAL(36, 18) NULL,                      -- Transaction fee
    nonce BIGINT NULL,                             -- Transaction nonce
    data TEXT NULL                                 -- Transaction data
);

-- Indexes for performance
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_blockchain_id ON transactions(blockchain_id);
CREATE INDEX idx_transactions_tx_hash ON transactions(tx_hash);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);

-- Foreign key constraints
ALTER TABLE transactions ADD CONSTRAINT fk_transactions_user_id 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE transactions ADD CONSTRAINT fk_transactions_blockchain_id 
    FOREIGN KEY (blockchain_id) REFERENCES blockchains(id) ON DELETE CASCADE;
```

### 2. User Documentation

#### User Guide
```markdown
# REChain VC Lab User Guide

## Getting Started

### What is REChain VC Lab?

REChain VC Lab is a comprehensive platform for managing blockchain technologies, Web3 applications, and decentralized systems. It provides tools for:

- **Web3 Development**: Build and deploy Web3 applications
- **Web4 Movement**: Create and manage social movements
- **Web5 Creation**: Develop and share creative content
- **Blockchain Management**: Manage multiple blockchain networks
- **Wallet Integration**: Secure wallet management

### System Requirements

#### Minimum Requirements
- **Operating System**: Windows 10, macOS 10.15, or Linux Ubuntu 18.04+
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 2GB available space
- **Internet**: Stable internet connection
- **Browser**: Chrome 90+, Firefox 88+, Safari 14+, or Edge 90+

#### Recommended Requirements
- **Operating System**: Windows 11, macOS 12+, or Linux Ubuntu 20.04+
- **RAM**: 16GB or more
- **Storage**: 10GB available space
- **Internet**: High-speed internet connection
- **Browser**: Latest version of Chrome, Firefox, Safari, or Edge

### Installation

#### Web Application
1. Open your web browser
2. Navigate to [https://vc.rechain.network](https://vc.rechain.network)
3. The application will load automatically
4. No installation required

#### Mobile Application
1. Open your device's app store
2. Search for "REChain VC Lab"
3. Tap "Install" or "Get"
4. Wait for installation to complete
5. Tap "Open" to launch the app

#### Desktop Application
1. Download the installer from [https://vc.rechain.network/download](https://vc.rechain.network/download)
2. Run the installer
3. Follow the installation wizard
4. Launch the application

### First Steps

#### Creating an Account
1. Click "Sign Up" on the home page
2. Enter your email address
3. Create a strong password
4. Verify your email address
5. Complete your profile

#### Setting Up Your Profile
1. Click on your profile picture
2. Select "Edit Profile"
3. Add your name and bio
4. Upload a profile picture
5. Set your preferences

#### Connecting a Wallet
1. Go to "Settings" > "Wallets"
2. Click "Add Wallet"
3. Select your wallet type
4. Follow the connection process
5. Verify your wallet address

## Web3 Tools

### Blockchain Management

#### Adding a Blockchain
1. Navigate to "Web3" > "Blockchains"
2. Click "Add Blockchain"
3. Select the blockchain type
4. Enter the RPC URL
5. Click "Save"

#### Managing Wallets
1. Go to "Web3" > "Wallets"
2. Click "Create Wallet" or "Import Wallet"
3. Follow the setup process
4. Secure your private key
5. Test your wallet

#### Sending Transactions
1. Go to "Web3" > "Transactions"
2. Click "Send Transaction"
3. Enter recipient address
4. Specify amount
5. Set gas parameters
6. Confirm transaction

### DeFi Integration

#### Lending and Borrowing
1. Navigate to "Web3" > "DeFi"
2. Select "Lending" or "Borrowing"
3. Choose your asset
4. Specify amount
5. Review terms
6. Confirm transaction

#### Staking
1. Go to "Web3" > "Staking"
2. Select your asset
3. Choose validator
4. Specify amount
5. Review rewards
6. Confirm stake

## Web4 Movement

### Creating a Movement

#### Basic Information
1. Navigate to "Web4" > "Movements"
2. Click "Create Movement"
3. Enter movement name
4. Add description
5. Select category
6. Set goals

#### Movement Settings
1. Set visibility (public/private)
2. Choose target audience
3. Set start and end dates
4. Define success metrics
5. Add tags

#### Inviting Participants
1. Go to "Web4" > "Movements" > "Your Movement"
2. Click "Invite Participants"
3. Enter email addresses
4. Add personal message
5. Send invitations

### Joining a Movement

#### Finding Movements
1. Go to "Web4" > "Discover"
2. Browse categories
3. Use search filters
4. Read descriptions
5. Check requirements

#### Joining Process
1. Click on a movement
2. Read the details
3. Check requirements
4. Click "Join Movement"
5. Complete onboarding

## Web5 Creation

### Creating Content

#### Content Types
- **Articles**: Written content and blog posts
- **Videos**: Video content and tutorials
- **Images**: Visual content and graphics
- **Code**: Code snippets and projects
- **Audio**: Podcasts and music

#### Content Creation Process
1. Go to "Web5" > "Create"
2. Select content type
3. Add title and description
4. Upload or create content
5. Set visibility and permissions
6. Add tags and categories
7. Publish content

### Collaboration

#### Working with Others
1. Invite collaborators
2. Set permissions
3. Share drafts
4. Review changes
5. Merge contributions

#### Version Control
1. Track changes
2. Create versions
3. Compare versions
4. Restore previous versions
5. Merge branches

## Advanced Features

### API Integration

#### Getting API Keys
1. Go to "Settings" > "API"
2. Click "Generate API Key"
3. Set permissions
4. Copy the key
5. Store securely

#### Using the API
1. Read the API documentation
2. Choose your programming language
3. Install the SDK
4. Authenticate with your API key
5. Make API calls

### Automation

#### Setting Up Workflows
1. Go to "Automation" > "Workflows"
2. Click "Create Workflow"
3. Choose triggers
4. Add actions
5. Test workflow
6. Activate

#### Scheduled Tasks
1. Navigate to "Automation" > "Scheduled Tasks"
2. Click "Create Task"
3. Set schedule
4. Choose action
5. Configure parameters
6. Save task

## Troubleshooting

### Common Issues

#### Login Problems
- **Forgot Password**: Use "Forgot Password" link
- **Account Locked**: Contact support
- **Two-Factor Authentication**: Use backup codes

#### Wallet Issues
- **Connection Failed**: Check internet connection
- **Wrong Network**: Switch to correct network
- **Insufficient Funds**: Add funds to wallet

#### Performance Issues
- **Slow Loading**: Clear browser cache
- **Crashes**: Update to latest version
- **Memory Issues**: Close other applications

### Getting Help

#### Support Channels
- **Email**: support@rechain.network
- **Live Chat**: Available 24/7
- **Community Forum**: [forum.rechain.network](https://forum.rechain.network)
- **Documentation**: [docs.rechain.network](https://docs.rechain.network)

#### Reporting Issues
1. Go to "Help" > "Report Issue"
2. Describe the problem
3. Include screenshots
4. Provide system information
5. Submit report

## Best Practices

### Security
- Use strong passwords
- Enable two-factor authentication
- Keep software updated
- Backup your data
- Be cautious with permissions

### Performance
- Close unused tabs
- Clear cache regularly
- Use recommended browsers
- Check internet connection
- Monitor system resources

### Collaboration
- Communicate clearly
- Respect others' work
- Follow community guidelines
- Provide constructive feedback
- Share knowledge

## Glossary

### Technical Terms
- **Blockchain**: Distributed ledger technology
- **Smart Contract**: Self-executing contract
- **DeFi**: Decentralized Finance
- **NFT**: Non-Fungible Token
- **Web3**: Decentralized web
- **Web4**: Social movement web
- **Web5**: Creative content web

### Platform Terms
- **Movement**: Social cause or initiative
- **Content**: Creative work or information
- **Wallet**: Digital asset storage
- **Transaction**: Blockchain operation
- **Staking**: Earning rewards by holding assets

## FAQ

### General Questions

**Q: Is REChain VC Lab free to use?**
A: Yes, the basic version is free. Premium features are available with a subscription.

**Q: Can I use multiple wallets?**
A: Yes, you can connect multiple wallets and switch between them.

**Q: Is my data secure?**
A: Yes, we use industry-standard encryption and security measures.

**Q: Can I export my data?**
A: Yes, you can export your data in various formats.

**Q: Do you offer customer support?**
A: Yes, we provide 24/7 customer support through multiple channels.

### Technical Questions

**Q: Which blockchains are supported?**
A: We support Ethereum, Polygon, BSC, Avalanche, Solana, and many more.

**Q: Can I develop custom integrations?**
A: Yes, we provide a comprehensive API and SDK.

**Q: Is there a mobile app?**
A: Yes, we have mobile apps for iOS and Android.

**Q: Can I use the platform offline?**
A: Some features work offline, but most require an internet connection.

**Q: Do you provide documentation for developers?**
A: Yes, we have comprehensive API documentation and guides.
```

### 3. API Documentation

#### OpenAPI Specification
```yaml
# openapi.yaml
openapi: 3.0.3
info:
  title: REChain VC Lab API
  description: |
    Comprehensive API for managing blockchain technologies, Web3 applications, 
    and decentralized systems. This API provides endpoints for user management, 
    blockchain operations, Web4 movements, and Web5 content creation.
  version: 1.0.0
  contact:
    name: API Support
    url: https://vc.rechain.network/support
    email: api-support@rechain.network
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT
servers:
  - url: https://api.rechain.network/v1
    description: Production server
  - url: https://staging-api.rechain.network/v1
    description: Staging server
  - url: https://dev-api.rechain.network/v1
    description: Development server
tags:
  - name: Users
    description: User management operations
  - name: Blockchains
    description: Blockchain network operations
  - name: Wallets
    description: Wallet management operations
  - name: Transactions
    description: Transaction operations
  - name: Movements
    description: Web4 movement operations
  - name: Content
    description: Web5 content operations
  - name: Authentication
    description: Authentication and authorization
paths:
  /users:
    get:
      tags:
        - Users
      summary: Get all users
      description: Retrieve a paginated list of users
      parameters:
        - name: page
          in: query
          description: Page number
          required: false
          schema:
            type: integer
            minimum: 1
            default: 1
        - name: limit
          in: query
          description: Number of users per page
          required: false
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
        - name: search
          in: query
          description: Search term for filtering users
          required: false
          schema:
            type: string
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/User'
                  pagination:
                    $ref: '#/components/schemas/Pagination'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '500':
          $ref: '#/components/responses/InternalServerError'
    post:
      tags:
        - Users
      summary: Create a new user
      description: Create a new user account
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: User created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          $ref: '#/components/responses/BadRequest'
        '409':
          $ref: '#/components/responses/Conflict'
        '500':
          $ref: '#/components/responses/InternalServerError'
  /users/{id}:
    get:
      tags:
        - Users
      summary: Get user by ID
      description: Retrieve a specific user by their ID
      parameters:
        - name: id
          in: path
          required: true
          description: User ID
          schema:
            type: string
      responses:
        '200':
          description: User found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'
        '500':
          $ref: '#/components/responses/InternalServerError'
    put:
      tags:
        - Users
      summary: Update user
      description: Update an existing user
      parameters:
        - name: id
          in: path
          required: true
          description: User ID
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateUserRequest'
      responses:
        '200':
          description: User updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          $ref: '#/components/responses/BadRequest'
        '404':
          $ref: '#/components/responses/NotFound'
        '500':
          $ref: '#/components/responses/InternalServerError'
    delete:
      tags:
        - Users
      summary: Delete user
      description: Delete a user account
      parameters:
        - name: id
          in: path
          required: true
          description: User ID
          schema:
            type: string
      responses:
        '204':
          description: User deleted successfully
        '404':
          $ref: '#/components/responses/NotFound'
        '500':
          $ref: '#/components/responses/InternalServerError'
components:
  schemas:
    User:
      type: object
      required:
        - id
        - name
        - email
        - createdAt
        - isActive
      properties:
        id:
          type: string
          description: Unique user identifier
          example: "123e4567-e89b-12d3-a456-426614174000"
        name:
          type: string
          description: User's full name
          example: "John Doe"
        email:
          type: string
          format: email
          description: User's email address
          example: "john@example.com"
        createdAt:
          type: string
          format: date-time
          description: Account creation timestamp
          example: "2024-01-01T00:00:00Z"
        isActive:
          type: boolean
          description: User account status
          example: true
        lastLogin:
          type: string
          format: date-time
          description: Last login timestamp
          example: "2024-01-15T10:30:00Z"
        emailVerified:
          type: boolean
          description: Email verification status
          example: true
        mfaEnabled:
          type: boolean
          description: Multi-factor authentication status
          example: false
        profileImageUrl:
          type: string
          format: uri
          description: Profile image URL
          example: "https://example.com/profile.jpg"
        timezone:
          type: string
          description: User's timezone
          example: "UTC"
        language:
          type: string
          description: User's preferred language
          example: "en"
        theme:
          type: string
          description: User's preferred theme
          example: "light"
    CreateUserRequest:
      type: object
      required:
        - name
        - email
        - password
      properties:
        name:
          type: string
          description: User's full name
          example: "John Doe"
        email:
          type: string
          format: email
          description: User's email address
          example: "john@example.com"
        password:
          type: string
          format: password
          description: User's password
          example: "SecurePassword123!"
        timezone:
          type: string
          description: User's timezone
          example: "UTC"
        language:
          type: string
          description: User's preferred language
          example: "en"
        theme:
          type: string
          description: User's preferred theme
          example: "light"
    UpdateUserRequest:
      type: object
      properties:
        name:
          type: string
          description: User's full name
          example: "Jane Doe"
        email:
          type: string
          format: email
          description: User's email address
          example: "jane@example.com"
        timezone:
          type: string
          description: User's timezone
          example: "UTC"
        language:
          type: string
          description: User's preferred language
          example: "en"
        theme:
          type: string
          description: User's preferred theme
          example: "dark"
    Pagination:
      type: object
      properties:
        page:
          type: integer
          description: Current page number
          example: 1
        limit:
          type: integer
          description: Number of items per page
          example: 20
        total:
          type: integer
          description: Total number of items
          example: 100
        pages:
          type: integer
          description: Total number of pages
          example: 5
    Error:
      type: object
      required:
        - message
        - code
      properties:
        message:
          type: string
          description: Error message
          example: "User not found"
        code:
          type: string
          description: Error code
          example: "USER_NOT_FOUND"
        details:
          type: object
          description: Additional error details
  responses:
    BadRequest:
      description: Bad request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    Unauthorized:
      description: Unauthorized
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    NotFound:
      description: Resource not found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    Conflict:
      description: Conflict
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    InternalServerError:
      description: Internal server error
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
security:
  - BearerAuth: []
  - ApiKeyAuth: []
```

## 📞 Contact Information

### Documentation Team
- **Email**: documentation@rechain.network
- **Phone**: +1-555-DOCUMENTATION
- **Slack**: #documentation channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Technical Writing Team
- **Email**: technical-writing@rechain.network
- **Phone**: +1-555-TECHNICAL-WRITING
- **Slack**: #technical-writing channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### User Experience Team
- **Email**: ux@rechain.network
- **Phone**: +1-555-UX
- **Slack**: #ux channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

---

**Creating comprehensive and accessible documentation! 📚**

*This documentation guide is effective as of September 4, 2024, and will be reviewed quarterly.*

**Last Updated**: 2024-09-04
**Version**: 1.0.0
**Documentation Guide Version**: 1.0.0
