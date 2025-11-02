# API Documentation Generation and OpenAPI Specification

This document provides comprehensive guidance on API documentation generation, OpenAPI specification management, and automated documentation workflows for the REChain VC Flutter project. It covers backend API documentation, blockchain API integration, client-side API usage, and automated documentation publishing.

## 📚 API Documentation Strategy

### Why API Documentation Matters
- **Developer Experience:** Clear, comprehensive API documentation for internal and external developers
- **Integration Support:** Blockchain API and third-party service documentation
- **Compliance:** Regulatory requirements for financial/blockchain APIs
- **Automation:** Automated documentation generation from code and specs
- **Versioning:** Maintain documentation for multiple API versions
- **Testing:** API documentation as part of automated testing workflows

### Supported Documentation Types
1. **OpenAPI/Swagger:** REST API specification and interactive documentation
2. **GraphQL Schema:** GraphQL API documentation and introspection
3. **Blockchain APIs:** Ethereum JSON-RPC, Web3, Ethers.js documentation
4. **gRPC Services:** Protocol buffer definitions and service documentation
5. **WebSocket APIs:** Real-time API documentation and message schemas
6. **Client SDKs:** Generated client libraries with documentation

## 🛠️ OpenAPI Specification Setup

### Core OpenAPI Specification
**openapi/rechain-vc-api.yaml:**
```yaml
openapi: 3.0.3
info:
  title: REChain VC API
  description: | 
    REChain VC is a cross-platform Flutter application for blockchain-based 
    verifiable credentials management. This API provides endpoints for wallet 
    management, credential verification, transaction processing, and blockchain 
    integration.
  version: 1.0.0
  contact:
    name: REChain VC Support
    url: https://rechain.vc/support
    email: support@rechain.vc
  license:
    name: MIT License
    url: https://opensource.org/licenses/MIT
  servers:
    - url: https://api.rechain.vc/v1
      description: Production server
    - url: https://staging-api.rechain.vc/v1
      description: Staging server
    - url: http://localhost:3000/v1
      description: Local development

components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
    WalletAuth:
      type: apiKey
      in: header
      name: X-Wallet-Address
  schemas:
    # Error Response
    ErrorResponse:
      type: object
      properties:
        code:
          type: string
          enum: [validation_error, authentication_error, authorization_error, rate_limit, server_error, blockchain_error]
          description: Error code for programmatic handling
        message:
          type: string
          description: Human-readable error message
        details:
          type: array
          items:
            type: object
            properties:
              field:
                type: string
                description: Field name for validation errors
              issue:
                type: string
                description: Specific validation issue
        correlationId:
          type: string
          description: Unique request identifier for debugging
        timestamp:
          type: string
          format: date-time
          description: When the error occurred
      required:
        - code
        - message
        - timestamp
      example:
        code: validation_error
        message: Invalid wallet address format
        details:
          - field: walletAddress
            issue: must be valid Ethereum address
        correlationId: "req-12345-67890"
        timestamp: "2024-09-06T18:00:00Z"

    # Success Response
    SuccessResponse:
      type: object
      properties:
        success:
          type: boolean
          description: Always true for successful responses
        data:
          type: object
          description: Response data
        meta:
          type: object
          properties:
            total:
              type: integer
              description: Total number of items (for paginated responses)
            page:
              type: integer
              description: Current page number
            perPage:
              type: integer
              description: Items per page
            totalPages:
              type: integer
              description: Total number of pages
            rateLimit:
              type: object
              properties:
                remaining:
                  type: integer
                  description: Remaining requests in current window
                reset:
                  type: integer
                  format: unix-time
                  description: Unix timestamp when rate limit resets
      required:
        - success
        - data
      example:
        success: true
        data: {}
        meta:
          total: 100
          page: 1
          perPage: 20
          totalPages: 5
          rateLimit:
            remaining: 95
            reset: 1725593600

    # Wallet Schema
    Wallet:
      type: object
      properties:
        id:
          type: string
          format: uuid
          description: Unique wallet identifier
        address:
          type: string
          pattern: ^0x[a-fA-F0-9]{40}$
          description: Ethereum wallet address
        name:
          type: string
          maxLength: 100
          description: User-friendly wallet name
        chainId:
          type: integer
          description: Blockchain network ID (1 for mainnet, 5 for Goerli, etc.)
          example: 1
        balance:
          type: number
          format: double
          description: Wallet balance in ETH
          example: 1.23456
        tokenBalance:
          type: object
          additionalProperties:
            type: number
            format: double
          description: ERC-20 token balances
          example:
            USDC: 1000.50
            DAI: 500.00
        lastActivity:
          type: string
          format: date-time
          description: Timestamp of last wallet activity
        isActive:
          type: boolean
          description: Whether the wallet is currently active
        createdAt:
          type: string
          format: date-time
          description: Wallet creation timestamp
        updatedAt:
          type: string
          format: date-time
          description: Last update timestamp
      required:
        - id
        - address
        - chainId
        - isActive
        - createdAt
        - updatedAt
      example:
        id: "550e8400-e29b-41d4-a716-446655440001"
        address: "0x742d35Cc6634C0532925a3b8D7D1bB6C7e8f9a1b"
        name: "My Main Wallet"
        chainId: 1
        balance: 1.23456
        tokenBalance:
          USDC: 1000.50
          DAI: 500.00
        lastActivity: "2024-09-06T12:34:56Z"
        isActive: true
        createdAt: "2024-01-01T00:00:00Z"
        updatedAt: "2024-09-06T12:34:56Z"

    # Credential Schema
    VerifiableCredential:
      type: object
      properties:
        id:
          type: string
          format: uuid
          description: Unique credential identifier
        type:
          type: array
          items:
            type: string
          description: Credential type(s) according to W3C VC spec
          example: ["VerifiableCredential", "UniversityDegreeCredential"]
        issuer:
          type: string
          description: DID of the credential issuer
          example: "did:ethr:0x123...456"
        issuanceDate:
          type: string
          format: date-time
          description: When the credential was issued
        expirationDate:
          type: string
          format: date-time
          description: When the credential expires (optional)
        credentialSubject:
          type: object
          description: Subject of the credential
          additionalProperties: true
          example:
            id: "did:ethr:0x789...abc"
            name: "John Doe"
            degree:
              type: "Bachelor"
              name: "Computer Science"
              institution: "MIT"
        proof:
          type: object
          description: Cryptographic proof of the credential
          additionalProperties: true
          example:
            type: "EcdsaSecp256k1Signature2019"
            created: "2024-09-06T12:34:56Z"
            proofPurpose: "assertionMethod"
            verificationMethod: "did:ethr:0x123...456#controller"
            jws: "eyJhbGciOiJFUzI1NiJ9..."
        status:
          type: string
          enum: [active, revoked, expired, superseded]
          description: Current status of the credential
        metadata:
          type: object
          properties:
            schemaVersion:
              type: string
              description: Schema version used
            storageLocation:
              type: string
              enum: [onchain, offchain, hybrid]
              description: Where the credential data is stored
            verificationLevel:
              type: string
              enum: [basic, advanced, zero_knowledge]
              description: Level of verification applied
          description: Additional metadata about the credential
      required:
        - id
        - type
        - issuer
        - issuanceDate
        - credentialSubject
        - proof
        - status
      example:
        id: "550e8400-e29b-41d4-a716-446655440002"
        type: ["VerifiableCredential", "UniversityDegreeCredential"]
        issuer: "did:ethr:0x1234567890abcdef1234567890abcdef12345678"
        issuanceDate: "2024-06-01T12:00:00Z"
        expirationDate: "2029-06-01T12:00:00Z"
        credentialSubject:
          id: "did:ethr:0x9876543210fedcba9876543210fedcba98765432"
          name: "John Doe"
          degree:
            type: "Bachelor"
            name: "Computer Science"
            institution: "MIT"
            year: 2024
        proof:
          type: "EcdsaSecp256k1Signature2019"
          created: "2024-06-01T12:05:00Z"
          proofPurpose: "assertionMethod"
          verificationMethod: "did:ethr:0x123...456#controller"
          jws: "eyJhbGciOiJFUzI1NiJ9..."
        status: "active"
        metadata:
          schemaVersion: "1.0.0"
          storageLocation: "onchain"
          verificationLevel: "advanced"

    # Pagination Schema
    Pagination:
      type: object
      properties:
        page:
          type: integer
          minimum: 1
          description: Current page number
        perPage:
          type: integer
          minimum: 1
          maximum: 100
          description: Number of items per page
        total:
          type: integer
          description: Total number of items
        totalPages:
          type: integer
          description: Total number of pages
        hasNext:
          type: boolean
          description: Whether there is a next page
        hasPrevious:
          type: boolean
          description: Whether there is a previous page
      required:
        - page
        - perPage
        - total
        - totalPages
        - hasNext
        - hasPrevious
      example:
        page: 1
        perPage: 20
        total: 150
        totalPages: 8
        hasNext: true
        hasPrevious: false

  parameters:
    Page:
      name: page
      in: query
      description: Page number
      required: false
      schema:
        type: integer
        default: 1
        minimum: 1
    PerPage:
      name: perPage
      in: query
      description: Items per page
      required: false
      schema:
        type: integer
        default: 20
        minimum: 1
        maximum: 100
    ChainId:
      name: chainId
      in: query
      description: Blockchain network ID
      required: false
      schema:
        type: integer
        default: 1
        example: 1
    WalletAddress:
      name: walletAddress
      in: query
      description: Ethereum wallet address
      required: false
      schema:
        type: string
        pattern: ^0x[a-fA-F0-9]{40}$

security:
  - BearerAuth: []
  - ApiKeyAuth: []
  - WalletAuth: []

paths:
  /health:
    get:
      tags:
        - Health Check
      summary: Health check endpoint
      description: Returns the health status of the API
      operationId: getHealth
      responses:
        '200':
          description: API is healthy
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SuccessResponse'
              example:
                success: true
                data:
                  status: "healthy"
                  version: "1.0.0"
                  uptime: 99.95
                meta: {}
        '503':
          description: API is unhealthy
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              example:
                code: server_error
                message: "Service temporarily unavailable"
                correlationId: "req-12345-67890"
                timestamp: "2024-09-06T18:00:00Z"

  /wallets:
    get:
      tags:
        - Wallets
      summary: Get wallets
      description: Retrieve a paginated list of wallets for the authenticated user
      operationId: getWallets
      parameters:
        - $ref: '#/components/parameters/Page'
        - $ref: '#/components/parameters/PerPage'
        - $ref: '#/components/parameters/ChainId'
      security:
        - BearerAuth: []
      responses:
        '200':
          description: Wallets retrieved successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/Wallet'
                  pagination:
                    $ref: '#/components/schemas/Pagination'
                required:
                  - data
                  - pagination
              example:
                data:
                  - $ref: '#/components/schemas/Wallet'
                pagination:
                  $ref: '#/components/schemas/Pagination'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              example:
                code: authentication_error
                message: "Invalid or missing authentication token"
        '403':
          description: Forbidden
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              example:
                code: authorization_error
                message: "User does not have permission to access wallets"

    post:
      tags:
        - Wallets
      summary: Create wallet
      description: Create a new wallet for the authenticated user
      operationId: createWallet
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                name:
                  type: string
                  maxLength: 100
                  description: User-friendly name for the wallet
                  example: "My Savings Wallet"
                chainId:
                  type: integer
                  description: Blockchain network ID
                  default: 1
                  example: 1
              required:
                - name
      security:
        - BearerAuth: []
      responses:
        '201':
          description: Wallet created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SuccessResponse'
              example:
                success: true
                data:
                  $ref: '#/components/schemas/Wallet'
                meta: {}
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              example:
                code: validation_error
                message: "Invalid wallet name or chain ID"
        '429':
          description: Rate limited
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              example:
                code: rate_limit
                message: "Too many wallet creation requests"

  /wallets/{walletId}:
    get:
      tags:
        - Wallets
      summary: Get wallet by ID
      description: Retrieve a specific wallet by its unique identifier
      operationId: getWalletById
      parameters:
        - name: walletId
          in: path
          required: true
          description: Unique wallet identifier
          schema:
            type: string
            format: uuid
      security:
        - BearerAuth: []
      responses:
        '200':
          description: Wallet found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SuccessResponse'
              example:
                success: true
                data:
                  $ref: '#/components/schemas/Wallet'
        '404':
          description: Wallet not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              example:
                code: validation_error
                message: "Wallet not found"

  /credentials:
    post:
      tags:
        - Credentials
      summary: Issue verifiable credential
      description: Issue a new verifiable credential for a subject
      operationId: issueCredential
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                type:
                  type: array
                  items:
                    type: string
                  description: Credential type(s)
                  example: ["VerifiableCredential", "IdentityCredential"]
                subject:
                  $ref: '#/components/schemas/VerifiableCredential/properties/credentialSubject'
                expirationDate:
                  type: string
                  format: date-time
                  description: Optional expiration date
                metadata:
                  $ref: '#/components/schemas/VerifiableCredential/properties/metadata'
              required:
                - type
                - subject
      security:
        - BearerAuth: []
        - ApiKeyAuth: []
      responses:
        '201':
          description: Credential issued successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SuccessResponse'
              example:
                success: true
                data:
                  $ref: '#/components/schemas/VerifiableCredential'
        '400':
          description: Invalid credential data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

    get:
      tags:
        - Credentials
      summary: Get credentials
      description: Retrieve paginated list of verifiable credentials
      operationId: getCredentials
      parameters:
        - $ref: '#/components/parameters/Page'
        - $ref: '#/components/parameters/PerPage'
        - $ref: '#/components/parameters/WalletAddress'
        - name: status
          in: query
          description: Filter by credential status
          required: false
          schema:
            type: array
            items:
              type: string
              enum: [active, revoked, expired, superseded]
            example: [active]
        - name: type
          in: query
          description: Filter by credential type
          required: false
          schema:
            type: array
            items:
              type: string
            example: ["UniversityDegreeCredential", "IdentityCredential"]
      security:
        - BearerAuth: []
        - WalletAuth: []
      responses:
        '200':
          description: Credentials retrieved successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/VerifiableCredential'
                  pagination:
                    $ref: '#/components/schemas/Pagination'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /credentials/verify:
    post:
      tags:
        - Credentials
      summary: Verify credential
      description: Verify the authenticity and validity of a verifiable credential
      operationId: verifyCredential
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                credential:
                  $ref: '#/components/schemas/VerifiableCredential'
                options:
                  type: object
                  properties:
                    checkExpiration:
                      type: boolean
                      default: true
                      description: Whether to check expiration date
                    checkRevocation:
                      type: boolean
                      default: true
                      description: Whether to check revocation status
                    checkIssuer:
                      type: boolean
                      default: true
                      description: Whether to verify issuer identity
                    proofMethod:
                      type: string
                      enum: [ecdsa, zkp, multi_sig]
                      description: Verification proof method
                      default: "ecdsa"
                  required: []
              required:
                - credential
      security:
        - ApiKeyAuth: []
      responses:
        '200':
          description: Credential verification result
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                    description: Whether verification was successful
                  valid:
                    type: boolean
                    description: Whether the credential is valid
                  issues:
                    type: array
                    items:
                      type: object
                      properties:
                        type:
                          type: string
                          enum: [signature_invalid, expired, revoked, issuer_invalid, schema_invalid]
                          description: Type of verification issue
                        description:
                          type: string
                          description: Detailed description of the issue
                        severity:
                          type: string
                          enum: [critical, warning, info]
                  verificationDetails:
                    type: object
                    properties:
                      signature:
                        type: object
                        properties:
                          valid:
                            type: boolean
                          method:
                            type: string
                      expiration:
                        type: object
                        properties:
                          valid:
                            type: boolean
                          expiresAt:
                            type: string
                            format: date-time
                      revocation:
                        type: object
                        properties:
                          valid:
                            type: boolean
                          statusListIndex:
                            type: integer
                      issuer:
                        type: object
                        properties:
                          valid:
                            type: boolean
                          did:
                            type: string
                            format: did
                  blockchain:
                    type: object
                    properties:
                      blockNumber:
                        type: integer
                        description: Block number of verification
                      transactionHash:
                        type: string
                        description: Transaction hash (if applicable)
                      gasUsed:
                        type: integer
                        description: Gas used for verification
                required:
                  - success
                  - valid
                  - issues
                  - verificationDetails
        '400':
          description: Invalid credential format
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /transactions:
    get:
      tags:
        - Transactions
      summary: Get transaction history
      description: Retrieve paginated transaction history for a wallet
      operationId: getTransactions
      parameters:
        - $ref: '#/components/parameters/Page'
        - $ref: '#/components/parameters/PerPage'
        - $ref: '#/components/parameters/WalletAddress'
        - name: fromDate
          in: query
          description: Start date for transaction history
          required: false
          schema:
            type: string
            format: date-time
        - name: toDate
          in: query
          description: End date for transaction history
          required: false
          schema:
            type: string
            format: date-time
        - name: type
          in: query
          description: Filter by transaction type
          required: false
          schema:
            type: array
            items:
              type: string
              enum: [send, receive, credential_issue, credential_verify, contract_call]
      security:
        - BearerAuth: []
        - WalletAuth: []
      responses:
        '200':
          description: Transaction history retrieved
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      type: object
                      properties:
                        id:
                          type: string
                          format: uuid
                        hash:
                          type: string
                          pattern: ^0x[a-fA-F0-9]{64}$
                          description: Blockchain transaction hash
                        from:
                          type: string
                          pattern: ^0x[a-fA-F0-9]{40}$
                        to:
                          type: string
                          pattern: ^0x[a-fA-F0-9]{40}$
                        value:
                          type: number
                          format: double
                          description: Transaction value in ETH
                        gasUsed:
                          type: integer
                          description: Gas used by the transaction
                        gasPrice:
                          type: number
                          format: double
                          description: Gas price in Gwei
                        blockNumber:
                          type: integer
                          description: Block number containing the transaction
                        timestamp:
                          type: string
                          format: date-time
                          description: Transaction timestamp
                        type:
                          type: string
                          enum: [send, receive, credential_issue, credential_verify, contract_call]
                          description: Transaction type
                        status:
                          type: string
                          enum: [pending, confirmed, failed]
                        fee:
                          type: number
                          format: double
                          description: Transaction fee in ETH
                        credentialId:
                          type: string
                          format: uuid
                          description: Related credential ID (if applicable)
                      required:
                        - id
                        - hash
                        - from
                        - to
                        - value
                        - timestamp
                        - type
                        - status
                  pagination:
                    $ref: '#/components/schemas/Pagination'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /blockchain/status:
    get:
      tags:
        - Blockchain
      summary: Get blockchain status
      description: Retrieve current blockchain network status and configuration
      operationId: getBlockchainStatus
      parameters:
        - $ref: '#/components/parameters/ChainId'
      responses:
        '200':
          description: Blockchain status
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  data:
                    type: object
                    properties:
                      chainId:
                        type: integer
                        description: Current chain ID
                      network:
                        type: string
                        enum: [mainnet, testnet, devnet]
                        description: Network type
                      latestBlock:
                        type: integer
                        description: Latest block number
                      syncStatus:
                        type: string
                        enum: [synced, syncing, stopped]
                        description: Node synchronization status
                      nodeVersion:
                        type: string
                        description: Node software version
                      gasPrice:
                        type: number
                        format: double
                        description: Current gas price in Gwei
                      blockTime:
                        type: number
                        format: double
                        description: Average block time in seconds
                      transactionCount:
                        type: integer
                        description: Transactions in latest block
                      difficulty:
                        type: number
                        format: double
                        description: Current mining difficulty
                      totalDifficulty:
                        type: number
                        format: double
                        description: Total mining difficulty
                    required:
                      - chainId
                      - network
                      - latestBlock
                      - syncStatus
                required:
                  - success
                  - data
        '400':
          description: Invalid chain ID
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /blockchain/balance/{walletAddress}:
    get:
      tags:
        - Blockchain
      summary: Get wallet balance
      description: Retrieve the current balance and token balances for a wallet address
      operationId: getWalletBalance
      parameters:
        - name: walletAddress
          in: path
          required: true
          description: Ethereum wallet address
          schema:
            type: string
            pattern: ^0x[a-fA-F0-9]{40}$
        - $ref: '#/components/parameters/ChainId'
      responses:
        '200':
          description: Wallet balance information
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  data:
                    type: object
                    properties:
                      address:
                        type: string
                        pattern: ^0x[a-fA-F0-9]{40}$
                      ethBalance:
                        type: string
                        description: ETH balance in wei
                      ethBalanceFormatted:
                        type: number
                        format: double
                        description: ETH balance in ETH (human readable)
                      nativeToken:
                        type: string
                        description: Native token symbol
                      tokenBalances:
                        type: array
                        items:
                          type: object
                          properties:
                            contractAddress:
                              type: string
                              pattern: ^0x[a-fA-F0-9]{40}$
                              description: ERC-20 token contract address
                            symbol:
                              type: string
                              description: Token symbol
                            name:
                              type: string
                              description: Token name
                            decimals:
                              type: integer
                              description: Token decimals
                            balance:
                              type: string
                              description: Token balance in smallest unit
                            balanceFormatted:
                              type: number
                              format: double
                              description: Token balance in human readable format
                            usdValue:
                              type: number
                              format: double
                              description: Approximate USD value
                          required:
                            - contractAddress
                            - symbol
                            - balance
                      totalValue:
                        type: number
                        format: double
                        description: Total portfolio value in USD
                      updatedAt:
                        type: string
                        format: date-time
                        description: When the balance was last updated
                    required:
                      - address
                      - ethBalance
                      - tokenBalances
                      - updatedAt
                required:
                  - success
                  - data
        '400':
          description: Invalid wallet address
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '429':
          description: Rate limited
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /webhook/credentials:
    post:
      tags:
        - Webhooks
      summary: Credential webhook
      description: Receive webhook notifications for credential events
      operationId: webhookCredentials
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                event:
                  type: string
                  enum: [credential_issued, credential_revoked, credential_verified, credential_expired]
                  description: Type of credential event
                credentialId:
                  type: string
                  format: uuid
                  description: ID of the affected credential
                walletAddress:
                  type: string
                  pattern: ^0x[a-fA-F0-9]{40}$
                  description: Wallet address involved in the event
                timestamp:
                  type: string
                  format: date-time
                  description: When the event occurred
                signature:
                  type: string
                  description: Cryptographic signature of the event
                data:
                  type: object
                  description: Event-specific data
                  additionalProperties: true
              required:
                - event
                - credentialId
                - walletAddress
                - timestamp
                - signature
      responses:
        '200':
          description: Webhook processed successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  processed:
                    type: boolean
                    description: Whether the webhook was successfully processed
                  eventId:
                    type: string
                    format: uuid
                    description: Unique ID for this webhook processing event
                required:
                  - success
                  - processed
                  - eventId
        '400':
          description: Invalid webhook payload
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '401':
          description: Invalid webhook signature
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

x-tagGroups:
  - name: Core
    tags:
      - Health Check
  - name: Wallets
    tags:
      - Wallets
  - name: Credentials
    tags:
      - Credentials
  - name: Transactions
    tags:
      - Transactions
  - name: Blockchain
    tags:
      - Blockchain
  - name: Webhooks
    tags:
      - Webhooks
```

### Backend API Documentation Generation
**package.json (scripts section):**
```json
{
  "scripts": {
    "docs:generate": "swagger-jsdoc -d swagger-def.js src/routes/*.js -o docs/api.json && swagger2md -i docs/api.json -o docs/api.md",
    "docs:serve": "swagger-ui-express docs/api.json",
    "docs:validate": "swagger-cli validate docs/api.yaml",
    "docs:lint": "swagger-cli lint docs/api.yaml",
    "docs:bundle": "swagger-cli bundle docs/api.yaml -o docs/api-bundle.yaml",
    "docs:typescript": "swagger-typescript-codegen --input docs/api.json --output src/types/api --name ApiClient",
    "docs:client": "swagger-codegen generate -i docs/api.yaml -l typescript-fetch -o generated/client"
  },
  "devDependencies": {
    "swagger-jsdoc": "^6.2.8",
    "swagger-ui-express": "^4.6.3",
    "swagger2md": "^1.0.0",
    "swagger-cli": "^4.0.4",
    "swagger-typescript-codegen": "^3.0.0",
    "swagger-codegen": "^2.4.22"
  }
}
```

**src/docs/swagger-def.js:**
```javascript
const swaggerJSDoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'REChain VC Backend API',
      version: '1.0.0',
      description: 'Backend API documentation for REChain VC Flutter application',
      contact: {
        name: 'API Support',
        email: 'api@rechain.vc'
      }
    },
    servers: [
      {
        url: 'https://api.rechain.vc/v1',
        description: 'Production'
      },
      {
        url: 'http://localhost:3000/v1',
        description: 'Local Development'
      }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        },
        apiKeyAuth: {
          type: 'apiKey',
          in: 'header',
          name: 'X-API-Key'
        }
      }
    },
    security: [
      {
        bearerAuth: []
      }
    ]
  },
  apis: ['./src/routes/*.js']
};

const specs = swaggerJSDoc(options);
module.exports = specs;
```

**src/routes/wallets.js (with JSDoc):**
```javascript
/**
 * @swagger
 * /v1/wallets:
 *   get:
 *     summary: Get user wallets
 *     description: Retrieve a paginated list of wallets associated with the authenticated user
 *     tags: [Wallets]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *         description: Page number for pagination
 *       - in: query
 *         name: perPage
 *         schema:
 *           type: integer
 *           default: 20
 *           maximum: 100
 *         description: Number of wallets per page
 *       - in: query
 *         name: chainId
 *         schema:
 *           type: integer
 *           default: 1
 *         description: Filter by blockchain network ID
 *     responses:
 *       200:
 *         description: Wallets retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Wallet'
 *                 pagination:
 *                   $ref: '#/components/schemas/Pagination'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       429:
 *         description: Rate limited
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 * 
 *   post:
 *     summary: Create new wallet
 *     description: Create a new wallet for the authenticated user
 *     tags: [Wallets]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 maxLength: 100
 *                 example: "My Savings Wallet"
 *                 description: User-friendly name for the wallet
 *               chainId:
 *                 type: integer
 *                 default: 1
 *                 example: 1
 *                 description: Blockchain network ID
 *             required:
 *               - name
 *     responses:
 *       201:
 *         description: Wallet created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/SuccessResponse'
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       429:
 *         description: Rate limited
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
const express = require('express');
const router = express.Router();
const walletService = require('../services/walletService');
const { authenticateToken, rateLimit } = require('../middleware/auth');

// GET /v1/wallets - Get user wallets
router.get(
  '/',
  authenticateToken,
  rateLimit({ windowMs: 15 * 60 * 1000, max: 100 }), // 100 requests per 15 minutes
  async (req, res) => {
    try {
      const { page = 1, perPage = 20, chainId } = req.query;
      const userId = req.user.id;
      
      const wallets = await walletService.getWallets(userId, {
        page: parseInt(page),
        perPage: parseInt(perPage),
        chainId: chainId ? parseInt(chainId) : undefined,
      });

      res.json({
        success: true,
        data: wallets.data,
        pagination: wallets.pagination,
      });
    } catch (error) {
      console.error('Error retrieving wallets:', error);
      res.status(500).json({
        code: 'server_error',
        message: 'Failed to retrieve wallets',
        correlationId: req.correlationId,
        timestamp: new Date().toISOString(),
      });
    }
  }
);

// POST /v1/wallets - Create new wallet
router.post(
  '/',
  authenticateToken,
  rateLimit({ windowMs: 60 * 60 * 1000, max: 5 }), // 5 wallets per hour
  async (req, res) => {
    try {
      const { name, chainId = 1 } = req.body;
      const userId = req.user.id;

      // Validation
      if (!name || name.length > 100) {
        return res.status(400).json({
          code: 'validation_error',
          message: 'Wallet name is required and must be less than 100 characters',
          details: [{ field: 'name', issue: 'invalid_length' }],
          correlationId: req.correlationId,
          timestamp: new Date().toISOString(),
        });
      }

      if (chainId < 1 || chainId > 1000) {
        return res.status(400).json({
          code: 'validation_error',
          message: 'Invalid chain ID',
          details: [{ field: 'chainId', issue: 'out_of_range' }],
          correlationId: req.correlationId,
          timestamp: new Date().toISOString(),
        });
      }

      const wallet = await walletService.createWallet(userId, {
        name,
        chainId: parseInt(chainId),
      });

      res.status(201).json({
        success: true,
        data: wallet,
      });
    } catch (error) {
      console.error('Error creating wallet:', error);
      
      if (error.code === 'RATE_LIMIT') {
        return res.status(429).json({
          code: 'rate_limit',
          message: 'Too many wallet creation requests. Please try again later.',
          correlationId: req.correlationId,
          timestamp: new Date().toISOString(),
        });
      }

      res.status(500).json({
        code: 'server_error',
        message: 'Failed to create wallet',
        correlationId: req.correlationId,
        timestamp: new Date().toISOString(),
      });
    }
  }
);

module.exports = router;
```

### GraphQL API Documentation
**schema.graphql:**
```graphql
# REChain VC GraphQL API Schema
# This schema defines the GraphQL interface for the REChain VC backend

type Query {
  # Wallet Queries
  wallet(id: ID!, chainId: Int): Wallet
  wallets(
    userId: ID!
    chainId: Int
    first: Int = 20
    after: String
    before: String
    last: Int
  ): WalletConnection!
  
  # Credential Queries
  credential(id: ID!): VerifiableCredential
  credentials(
    walletAddress: String
    status: CredentialStatus
    type: [String!]
    first: Int = 20
    after: String
    before: String
    last: Int
  ): CredentialConnection!

  # Transaction Queries
  transaction(hash: String!, chainId: Int!): Transaction
  transactions(
    walletAddress: String!
    chainId: Int!
    type: TransactionType
    first: Int = 20
    after: String
    before: String
    last: Int
  ): TransactionConnection!

  # Blockchain Queries
  blockchainStatus(chainId: Int!): BlockchainStatus!
  walletBalance(address: String!, chainId: Int!): WalletBalance!
  blockNumber(chainId: Int!): Int!
  latestBlock(chainId: Int!): Block!

  # Health Check
  health: HealthStatus!
}

type Mutation {
  # Wallet Mutations
  createWallet(name: String!, chainId: Int!): Wallet!
  updateWallet(id: ID!, name: String): Wallet!
  deleteWallet(id: ID!): Boolean!
  connectWallet(address: String!, chainId: Int!): WalletConnection!

  # Credential Mutations
  issueCredential(
    type: [String!]!
    subject: CredentialSubjectInput!
    expirationDate: DateTime
    metadata: CredentialMetadataInput
  ): VerifiableCredential!
  revokeCredential(id: ID!): Boolean!
  verifyCredential(credential: VerifiableCredentialInput!): CredentialVerification!
  storeCredential(credential: VerifiableCredentialInput!, walletAddress: String!): StoredCredential!

  # Transaction Mutations
  sendTransaction(
    to: String!
    value: Float!
    chainId: Int!
    data: String
    gasPrice: Float
    gasLimit: Int
  ): Transaction!
  signTransaction(
    transaction: TransactionInput!
    walletId: ID!
  ): SignedTransaction!
  broadcastTransaction(signedTx: SignedTransactionInput!): Transaction!

  # Blockchain Mutations
  addNetwork(chainId: Int!, rpcUrl: String!, chainName: String!): Boolean!
  switchNetwork(chainId: Int!): Boolean!
}

type Subscription {
  # Real-time Updates
  walletBalanceChanged(address: String!, chainId: Int!): WalletBalanceUpdate!
  newTransaction(walletAddress: String!, chainId: Int!): Transaction!
  credentialStatusChanged(credentialId: ID!): CredentialStatusUpdate!
  blockchainEvents(chainId: Int!, eventType: String!): BlockchainEvent!
}

# Input Types
input CredentialSubjectInput {
  id: ID!
  data: JSON!
}

input CredentialMetadataInput {
  schemaVersion: String
  storageLocation: StorageLocation = ONCHAIN
  verificationLevel: VerificationLevel = BASIC
}

input TransactionInput {
  to: String!
  value: Float!
  data: String
  gasPrice: Float
  gasLimit: Int
  nonce: Int
  chainId: Int!
}

input SignedTransactionInput {
  rawTransaction: String!
  signature: String!
  chainId: Int!
}

# Enum Types
enum CredentialStatus {
  ACTIVE
  REVOKED
  EXPIRED
  SUPERSEDED
}

enum StorageLocation {
  ONCHAIN
  OFFCHAIN
  HYBRID
}

enum VerificationLevel {
  BASIC
  ADVANCED
  ZERO_KNOWLEDGE
}

enum TransactionType {
  SEND
  RECEIVE
  CREDENTIAL_ISSUE
  CREDENTIAL_VERIFY
  CONTRACT_CALL
}

# Core Types
type Wallet {
  id: ID!
  address: String!
  name: String!
  chainId: Int!
  balance: Float!
  tokenBalances: [TokenBalance!]!
  createdAt: DateTime!
  updatedAt: DateTime!
  transactions(first: Int, after: String): TransactionConnection!
}

type WalletConnection {
  edges: [WalletEdge!]!
  pageInfo: PageInfo!
}

type WalletEdge {
  node: Wallet!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

type TokenBalance {
  contractAddress: String!
  symbol: String!
  name: String!
  decimals: Int!
  balance: Float!
  usdValue: Float!
}

type VerifiableCredential {
  id: ID!
  type: [String!]!
  issuer: String!
  issuanceDate: DateTime!
  expirationDate: DateTime
  credentialSubject: JSON!
  proof: JSON!
  status: CredentialStatus!
  metadata: CredentialMetadata!
  wallet: Wallet
}

type CredentialConnection {
  edges: [CredentialEdge!]!
  pageInfo: PageInfo!
}

type CredentialEdge {
  node: VerifiableCredential!
  cursor: String!
}

type CredentialMetadata {
  schemaVersion: String!
  storageLocation: StorageLocation!
  verificationLevel: VerificationLevel!
}

type CredentialVerification {
  valid: Boolean!
  issues: [VerificationIssue!]!
  blockchainVerification: BlockchainVerification!
}

type VerificationIssue {
  type: String!
  description: String!
  severity: String!
  field: String
  suggestion: String
}

type BlockchainVerification {
  blockNumber: Int
  transactionHash: String
  gasUsed: Int
  timestamp: DateTime
}

type Transaction {
  id: ID!
  hash: String!
  from: String!
  to: String!
  value: Float!
  gasUsed: Int!
  gasPrice: Float!
  blockNumber: Int!
  timestamp: DateTime!
  type: TransactionType!
  status: String!
  fee: Float!
  credentialId: ID
  confirmations: Int!
}

type TransactionConnection {
  edges: [TransactionEdge!]!
  pageInfo: PageInfo!
}

type TransactionEdge {
  node: Transaction!
  cursor: String!
}

type BlockchainStatus {
  chainId: Int!
  network: String!
  latestBlock: Int!
  syncStatus: String!
  nodeVersion: String!
  gasPrice: Float!
  blockTime: Float!
  transactionCount: Int!
  difficulty: Float!
}

type WalletBalance {
  address: String!
  ethBalance: String!
  ethBalanceFormatted: Float!
  nativeToken: String!
  tokenBalances: [TokenBalance!]!
  totalValue: Float!
  updatedAt: DateTime!
}

type HealthStatus {
  status: String!
  version: String!
  uptime: Float!
  database: DatabaseStatus!
  blockchain: BlockchainHealth!
  services: [ServiceStatus!]!
}

type DatabaseStatus {
  connected: Boolean!
  version: String!
  activeConnections: Int!
  queryTime: Float!
}

type BlockchainHealth {
  connected: Boolean!
  synced: Boolean!
  latestBlock: Int!
  peers: Int!
  chainId: Int!
}

type ServiceStatus {
  name: String!
  healthy: Boolean!
  responseTime: Float!
  errors: [String!]!
}

type SignedTransaction {
  rawTransaction: String!
  signature: String!
  hash: String!
  from: String!
  to: String!
  value: Float!
  gasPrice: Float!
  gasLimit: Int!
  nonce: Int!
  chainId: Int!
  data: String!
}

type StoredCredential {
  id: ID!
  walletId: ID!
  credentialHash: String!
  storageLocation: StorageLocation!
  accessMethod: String!
  createdAt: DateTime!
}

type WalletBalanceUpdate {
  address: String!
  chainId: Int!
  previousBalance: Float!
  newBalance: Float!
  change: Float!
  timestamp: DateTime!
  transactionHash: String
}

type CredentialStatusUpdate {
  credentialId: ID!
  previousStatus: CredentialStatus!
  newStatus: CredentialStatus!
  reason: String
  timestamp: DateTime!
}

type BlockchainEvent {
  chainId: Int!
  eventType: String!
  blockNumber: Int!
  transactionHash: String!
  data: JSON!
  timestamp: DateTime!
}

# Scalar Types
scalar DateTime
scalar JSON
scalar Upload

# Pagination
type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

# Standard Response Wrappers
type QueryResponse {
  success: Boolean!
  data: JSON!
  errors: [String!]
  pagination: PageInfo
}

type MutationResponse {
  success: Boolean!
  data: JSON!
  errors: [String!]
}
```

### GraphQL Documentation Generation
**package.json (GraphQL docs scripts):**
```json
{
  "scripts": {
    "graphql:docs": "graphql-docs --schema schema.graphql --out docs/graphql",
    "graphql:playground": "graphql-playground-lambda serve --schema schema.graphql",
    "graphql:client": "graphql-codegen --config codegen.yml",
    "graphql:validate": "graphql-cli validate --schema schema.graphql",
    "graphql:bundle": "graphql-cli bundle --schema schema.graphql --out docs/graphql-schema.graphql"
  },
  "devDependencies": {
    "graphql-docs": "^4.0.0",
    "graphql-playground-lambda": "^1.7.23",
    "@graphql-codegen/cli": "^2.13.0",
    "@graphql-codegen/typescript": "^2.5.0",
    "@graphql-codegen/typescript-operations": "^2.5.0",
    "@graphql-codegen/typescript-react-apollo": "^3.3.0",
    "graphql-cli": "^7.0.0"
  }
}
```

**.graphqlconfig:**
```json
{
  "name": "REChain VC GraphQL",
  "version": 0.1,
  "schemaPath": "schema.graphql",
  "extensions": {
    "endpoints": {
      "default": {
        "url": "http://localhost:4000/graphql",
        "headers": {
          "Authorization": "Bearer YOUR_TOKEN"
        }
      },
      "production": {
        "url": "https://api.rechain.vc/graphql",
        "headers": {
          "Authorization": "Bearer PROD_TOKEN"
        }
      }
    }
  }
}
```

**codegen.yml:**
```yaml
schema: schema.graphql
documents: 'src/**/*.graphql'
generates:
  src/types/graphql.ts:
    plugins:
      - typescript
      - typescript-operations
      - typescript-react-apollo
    config:
      withHooks: true
      withComponent: false
      withHOC: false
  src/types/graphql.schema.json:
    plugins:
      - introspection
  docs/graphql/index.html:
    plugins:
      - playground
  docs/graphql/schema.graphql:
    plugins:
      - schema-ast
```

## 🔧 Automated Documentation Generation

### GitHub Actions for API Documentation
**.github/workflows/api-docs.yml:**
```yaml
name: API Documentation Generation

on:
  push:
    branches: [ main, develop ]
    paths: 
      - 'src/routes/**'
      - 'src/services/**'
      - 'schema.graphql'
      - 'openapi/**'
      - 'docs/api/**'
  pull_request:
    branches: [ main ]
    paths:
      - 'src/routes/**'
      - 'src/services/**'
      - 'schema.graphql'
      - 'openapi/**'
      - 'docs/api/**'
  workflow_dispatch:
    inputs:
      publish_docs:
        description: 'Publish updated API documentation to GitHub Pages'
        required: false
        default: 'false'
        type: boolean

jobs:
  generate-docs:
    name: Generate API Documentation
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
          cache: 'pip'

      - name: Install dependencies
        run: |
          # Backend dependencies
          npm ci
          
          # Python dependencies for documentation
          pip install sphinx recommonmark sphinx-rtd-theme
          
          # GraphQL tools
          npm install -g @graphql-codegen/cli graphql-cli

      - name: Generate OpenAPI Documentation
        run: |
          # Generate from code comments
          npm run docs:generate
          
          # Validate OpenAPI spec
          npm run docs:validate
          
          # Lint OpenAPI spec
          npm run docs:lint
          
          # Bundle OpenAPI spec
          npm run docs:bundle
          
          # Generate TypeScript types
          npm run docs:typescript
          
          # Generate client SDK
          npm run docs:client

      - name: Generate GraphQL Documentation
        run: |
          # Generate GraphQL docs
          npm run graphql:docs
          
          # Validate GraphQL schema
          npm run graphql:validate
          
          # Bundle GraphQL schema
          npm run graphql:bundle
          
          # Generate GraphQL client types
          npm run graphql:client

      - name: Generate Markdown Documentation
        run: |
          # Convert OpenAPI to Markdown
          swagger2md -i docs/api-bundle.yaml -o docs/api.md
          
          # Generate GraphQL Markdown docs
          graphql-docs --markdown --schema schema.graphql --out docs/graphql-md
          
          # Generate comprehensive API guide
          python scripts/generate_api_guide.py > docs/api-guide.md

      - name: Validate Documentation
        run: |
          # Check for broken links
          python -m pip install broken
          broken docs/api.md docs/graphql-md/*.md
          
          # Validate code examples
          python scripts/validate_code_examples.py docs/
          
          # Check for outdated references
          python scripts/check_deprecated.py docs/

      - name: Build HTML Documentation
        run: |
          # Build Sphinx documentation
          cd docs && sphinx-build -b html . _build/html
          
          # Generate Swagger UI
          npx swagger-ui-dist docs/api-bundle.yaml > docs/_build/html/swagger-ui/index.html

      - name: Upload Generated Documentation
        uses: actions/upload-artifact@v4
        with:
          name: api-documentation
          path: |
            docs/api*.json
            docs/api*.yaml
            docs/api.md
            docs/graphql-md/
            docs/_build/html/
            src/types/api/
            generated/client/
          retention-days: 30

      - name: Publish to GitHub Pages
        if: github.ref == 'refs/heads/main' && inputs.publish_docs == 'true'
        run: |
          # Deploy to GitHub Pages
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          
          # Create gh-pages branch
          git checkout -b gh-pages
          
          # Copy documentation
          mkdir -p docs/html
          cp -r docs/_build/html/* docs/html/
          
          # Add API specs
          cp docs/api-bundle.yaml docs/html/api.yaml
          cp docs/graphql-schema.graphql docs/html/graphql-schema.graphql
          
          # Commit and push
          git add docs/
          git commit -m "Update API documentation [skip ci]" || exit 0
          git push -f origin gh-pages
          
          # Set up GitHub Pages
          gh pages --deploy --repo ${{ github.repository }} --dir docs/html --message "Deploy API docs"

      - name: Create Documentation PR
        if: github.event_name == 'pull_request'
        run: |
          # Create PR with updated docs if changed
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          
          git add docs/ src/types/
          if git diff --staged --quiet; then
            echo "No documentation changes"
          else
            git commit -m "Update API documentation [skip ci]"
            git push origin HEAD:${{ github.head_ref }}
            
            # Create comment on PR
            gh pr comment ${{ github.event.pull_request.number }} --body "📚 API documentation has been automatically updated based on your changes."
          fi
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Documentation Alert
        if: failure()
        uses: 8398a7/action-slack@v3
        with:
          status: failure
          text: "📚 *API Documentation Generation Failed*\n\nReview the validation errors and fix the API specifications."
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

  docs-validation:
    name: Documentation Validation
    runs-on: ubuntu-latest
    needs: generate-docs
    steps:
      - name: Download Documentation
        uses: actions/download-artifact@v4
        with:
          name: api-documentation

      - name: Validate Documentation Links
        run: |
          # Check for broken links in Markdown
          python scripts/check_broken_links.py docs/
          
          # Validate OpenAPI examples
          python scripts/validate_openapi_examples.py docs/api-bundle.yaml
          
          # Check GraphQL examples
          python scripts/validate_graphql_examples.py docs/graphql-schema.graphql

      - name: Generate Documentation Coverage Report
        run: |
          # Analyze documentation completeness
          python scripts/docs_coverage.py docs/
          
          # Check for missing endpoint documentation
          python scripts/check_missing_docs.py src/routes/ docs/api.md
          
          # Verify code examples are up-to-date
          python scripts/verify_code_examples.py src/ docs/

      - name: Upload Validation Report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: documentation-validation-report
          path: |
            docs-coverage.md
            broken-links.md
            missing-docs.md
          retention-days: 14

      - name: Documentation Quality Alert
        if: failure()
        uses: 8398a7/action-slack@v3
        with:
          status: failure
          text: "📚 *Documentation Quality Issues Detected*\n\nReview the validation report for broken links, missing documentation, and outdated examples."
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

  publish-docs:
    name: Publish API Documentation
    runs-on: ubuntu-latest
    needs: [generate-docs, docs-validation]
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Download Generated Documentation
        uses: actions/download-artifact@v4
        with:
          name: api-documentation
          path: docs/

      - name: Setup GitHub Pages
        run: |
          # Create documentation site structure
          mkdir -p public
          
          # Copy HTML documentation
          cp -r docs/_build/html/* public/
          
          # Create API reference landing page
          cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <title>REChain VC API Documentation</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@4.15.5/swagger-ui.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans">
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist@4.15.5/swagger-ui-bundle.js" crossorigin></script>
  <script src="https://unpkg.com/swagger-ui-dist@4.15.5/swagger-ui-standalone-preset.js" crossorigin></script>
  <script>
    window.onload = function() {
      const ui = SwaggerUIBundle({
        url: "api.yaml",
        dom_id: '#swagger-ui',
        presets: [
          SwaggerUIBundle.presets.apis,
          SwaggerUIBundle.presets.fetch,
          SwaggerUIStandalonePreset
        ],
        plugins: [
          SwaggerUIBundle.plugins.DownloadUrl
        ],
        layout: "StandaloneLayout",
        docExpansion: "none",
        filter: true,
        filterFullyHideEmpty: true,
        tryItOutEnabled: true,
        validatorUrl: null
      });
      
      window.ui = ui;
    };
  </script>
  <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
</body>
</html>
EOF

          # Copy API specs to public directory
          cp docs/api-bundle.yaml public/api.yaml
          cp docs/graphql-schema.graphql public/graphql-schema.graphql
          
          # Create GraphQL documentation page
          cat > public/graphql.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <title>GraphQL API Documentation</title>
  <meta charset="utf-8">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/graphiql@2.1.6/graphiql.min.css">
  <script src="https://cdn.jsdelivr.net/npm/graphiql@2.1.6/graphiql.min.js"></script>
</head>
<body style="margin: 0;">
  <div id="graphiql">Loading...</div>
  <script>
    const { GraphiQL } = window.GraphiQL;
    const { createSchema } = window.fetcher;
    
    const response = await fetch('graphql-schema.graphql');
    const schemaSDL = await response.text();
    const schema = createSchema(schemaSDL);
    
    ReactDOM.render(
      React.createElement(GraphiQL, {
        schema,
        fetcher: window.fetcher,
        defaultQuery: `# Welcome to GraphQL API Documentation
#
# Explore the REChain VC GraphQL API
# 
# Available queries:
# - wallet(id: ID!): Wallet
# - credentials(walletAddress: String): [VerifiableCredential]
# - transactions(walletAddress: String!): [Transaction]
#
query ExampleQuery {
  wallet(id: "550e8400-e29b-41d4-a716-446655440001") {
    id
    address
    balance
    tokenBalances {
      symbol
      balance
    }
  }
}`,
      }),
      document.getElementById('graphiql')
    );
  </script>
</body>
</html>
EOF

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
          destination_dir: ./api-docs
          user_name: 'github-actions[bot]'
          user_email: 'github-actions[bot]@users.noreply.github.com'
          commit_message: 'Update API documentation - {{ github.sha }}'
          enable_jekyll: false
          publish_branch: gh-pages
          exclude_assets: '.github,*.md'

      - name: Create Documentation Release
        if: github.ref == 'refs/heads/main'
        run: |
          # Create GitHub release for documentation
          gh release create v$(date +%Y%m%d)-docs \
            docs/api-bundle.yaml#API Specification \
            docs/graphql-schema.graphql#GraphQL Schema \
            docs/api.md#REST API Documentation \
            docs/graphql-md/index.md#GraphQL Documentation \
            --title "API Documentation $(date +%Y-%m-%d)" \
            --notes "Automated API documentation release" \
            --generate-notes
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Notify Documentation Update
        if: success()
        uses: 8398a7/action-slack@v3
        with:
          status: success
          text: "📚 *API Documentation Updated*\n\nNew API documentation published to GitHub Pages.\n\n- OpenAPI: https://rechain.vc/api-docs/api.yaml\n- GraphQL: https://rechain.vc/api-docs/graphql.html\n- Full docs: https://rechain.vc/api-docs/"
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

  docs-review:
    name: Documentation Review
    runs-on: ubuntu-latest
    needs: [generate-docs, publish-docs]
    if: github.event_name == 'pull_request'
    steps:
      - name: Comment on PR with Documentation Status
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            
            let comment = '## 📚 API