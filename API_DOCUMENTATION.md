# API Documentation - REChain VC Lab

## 📚 Overview

REChain VC Lab provides a comprehensive API for blockchain development, Web4 Movement concepts, and Web5 Creation tools. This documentation covers all available endpoints, data models, and integration examples.

## 🔗 Base URLs

- **Development**: `https://dev-api.rechain.network`
- **Staging**: `https://staging-api.rechain.network`
- **Production**: `https://api.rechain.network`

## 🔐 Authentication

### API Key Authentication
```http
Authorization: Bearer YOUR_API_KEY
```

### JWT Token Authentication
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 📱 Web3 Blockchain API

### Get Account Balance
```http
GET /api/v1/blockchain/balance/{address}
```

**Parameters:**
- `address` (string, required): Ethereum wallet address
- `chainId` (integer, optional): Blockchain network ID (default: 1)

**Response:**
```json
{
  "success": true,
  "data": {
    "address": "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6",
    "balance": "1.234567890123456789",
    "balanceWei": "1234567890123456789",
    "chainId": 1,
    "symbol": "ETH",
    "decimals": 18
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

### Get Transaction History
```http
GET /api/v1/blockchain/transactions/{address}
```

**Parameters:**
- `address` (string, required): Ethereum wallet address
- `page` (integer, optional): Page number (default: 1)
- `limit` (integer, optional): Items per page (default: 20)
- `chainId` (integer, optional): Blockchain network ID (default: 1)

**Response:**
```json
{
  "success": true,
  "data": {
    "transactions": [
      {
        "hash": "0x1234567890abcdef...",
        "from": "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6",
        "to": "0x9876543210fedcba...",
        "value": "0.001",
        "valueWei": "1000000000000000",
        "gasUsed": "21000",
        "gasPrice": "20000000000",
        "blockNumber": 18500000,
        "timestamp": "2024-09-04T13:45:00Z",
        "status": "success"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "pages": 8
    }
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

### Send Transaction
```http
POST /api/v1/blockchain/send
```

**Request Body:**
```json
{
  "from": "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6",
  "to": "0x9876543210fedcba...",
  "value": "0.001",
  "gasLimit": 21000,
  "gasPrice": "20000000000",
  "chainId": 1,
  "privateKey": "0x1234567890abcdef..."
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "hash": "0x1234567890abcdef...",
    "status": "pending",
    "gasUsed": "21000",
    "gasPrice": "20000000000",
    "blockNumber": null,
    "timestamp": "2024-09-04T14:00:00Z"
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

## 🌐 Web4 Movement API

### Get Movement Data
```http
GET /api/v1/web4/movement
```

**Parameters:**
- `type` (string, optional): Movement type (social, economic, technological)
- `category` (string, optional): Movement category
- `limit` (integer, optional): Number of results (default: 20)

**Response:**
```json
{
  "success": true,
  "data": {
    "movements": [
      {
        "id": "mov_123456789",
        "name": "Decentralized Social Networks",
        "type": "social",
        "category": "community",
        "description": "Movement towards decentralized social platforms",
        "participants": 12500,
        "growth": 15.5,
        "trending": true,
        "tags": ["decentralization", "social", "web4"],
        "createdAt": "2024-09-01T10:00:00Z",
        "updatedAt": "2024-09-04T14:00:00Z"
      }
    ],
    "total": 150,
    "page": 1,
    "limit": 20
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

### Create Movement
```http
POST /api/v1/web4/movement
```

**Request Body:**
```json
{
  "name": "AI-Powered Governance",
  "type": "technological",
  "category": "governance",
  "description": "Movement towards AI-assisted decentralized governance",
  "tags": ["ai", "governance", "web4"],
  "metadata": {
    "goals": ["Transparency", "Efficiency", "Participation"],
    "targetAudience": "DAO members",
    "expectedDuration": "6 months"
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "mov_987654321",
    "name": "AI-Powered Governance",
    "type": "technological",
    "category": "governance",
    "description": "Movement towards AI-assisted decentralized governance",
    "participants": 1,
    "growth": 0,
    "trending": false,
    "tags": ["ai", "governance", "web4"],
    "createdAt": "2024-09-04T14:00:00Z",
    "updatedAt": "2024-09-04T14:00:00Z"
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

## 🎨 Web5 Creation API

### Get Creation Tools
```http
GET /api/v1/web5/creation/tools
```

**Parameters:**
- `category` (string, optional): Tool category (design, development, content)
- `type` (string, optional): Tool type (template, generator, editor)
- `limit` (integer, optional): Number of results (default: 20)

**Response:**
```json
{
  "success": true,
  "data": {
    "tools": [
      {
        "id": "tool_123456789",
        "name": "Smart Contract Generator",
        "category": "development",
        "type": "generator",
        "description": "AI-powered smart contract generator",
        "features": [
          "Template-based generation",
          "Custom logic integration",
          "Security validation",
          "Gas optimization"
        ],
        "pricing": {
          "free": true,
          "premium": false,
          "credits": 0
        },
        "rating": 4.8,
        "downloads": 12500,
        "createdAt": "2024-08-15T10:00:00Z",
        "updatedAt": "2024-09-04T14:00:00Z"
      }
    ],
    "total": 75,
    "page": 1,
    "limit": 20
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

### Create Content
```http
POST /api/v1/web5/creation/content
```

**Request Body:**
```json
{
  "type": "smart_contract",
  "template": "erc20_token",
  "parameters": {
    "name": "MyToken",
    "symbol": "MTK",
    "decimals": 18,
    "totalSupply": "1000000000"
  },
  "customizations": {
    "mintable": true,
    "burnable": true,
    "pausable": false
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "content_987654321",
    "type": "smart_contract",
    "template": "erc20_token",
    "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract MyToken {\n    // ... generated contract code\n}",
    "metadata": {
      "name": "MyToken",
      "symbol": "MTK",
      "decimals": 18,
      "totalSupply": "1000000000",
      "features": ["mintable", "burnable"]
    },
    "createdAt": "2024-09-04T14:00:00Z",
    "updatedAt": "2024-09-04T14:00:00Z"
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

## 📊 Analytics API

### Get Platform Analytics
```http
GET /api/v1/analytics/platform
```

**Parameters:**
- `period` (string, optional): Time period (day, week, month, year)
- `startDate` (string, optional): Start date (ISO 8601)
- `endDate` (string, optional): End date (ISO 8601)

**Response:**
```json
{
  "success": true,
  "data": {
    "period": "month",
    "startDate": "2024-08-01T00:00:00Z",
    "endDate": "2024-08-31T23:59:59Z",
    "metrics": {
      "totalUsers": 12500,
      "activeUsers": 8500,
      "newUsers": 1200,
      "totalTransactions": 45000,
      "totalVolume": "125.5",
      "averageSessionDuration": "15.5",
      "bounceRate": 0.25
    },
    "trends": {
      "users": {
        "growth": 15.5,
        "trend": "increasing"
      },
      "transactions": {
        "growth": 22.3,
        "trend": "increasing"
      },
      "volume": {
        "growth": 18.7,
        "trend": "increasing"
      }
    }
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

## 🔧 Configuration API

### Get App Configuration
```http
GET /api/v1/config/app
```

**Response:**
```json
{
  "success": true,
  "data": {
    "version": "1.0.0",
    "features": {
      "web4": true,
      "web5": true,
      "analytics": true,
      "notifications": true
    },
    "blockchain": {
      "supportedChains": [1, 137, 56, 250],
      "defaultChain": 1,
      "rpcUrls": {
        "1": "https://mainnet.infura.io/v3/your_project_id",
        "137": "https://polygon-rpc.com",
        "56": "https://bsc-dataseed.binance.org",
        "250": "https://rpc.ftm.tools"
      }
    },
    "ui": {
      "theme": "dark",
      "language": "en",
      "currency": "USD"
    }
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

## 📱 Mobile App Integration

### Flutter/Dart Example
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class REChainAPI {
  static const String baseUrl = 'https://api.rechain.network';
  static const String apiKey = 'YOUR_API_KEY';
  
  static Future<Map<String, dynamic>> getBalance(String address) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/blockchain/balance/$address'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load balance');
    }
  }
  
  static Future<Map<String, dynamic>> createMovement(Map<String, dynamic> movementData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/web4/movement'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode(movementData),
    );
    
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create movement');
    }
  }
}
```

### JavaScript/Web Example
```javascript
class REChainAPI {
  constructor(apiKey) {
    this.baseUrl = 'https://api.rechain.network';
    this.apiKey = apiKey;
  }
  
  async getBalance(address) {
    const response = await fetch(`${this.baseUrl}/api/v1/blockchain/balance/${address}`, {
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
        'Content-Type': 'application/json',
      },
    });
    
    if (!response.ok) {
      throw new Error('Failed to load balance');
    }
    
    return await response.json();
  }
  
  async createMovement(movementData) {
    const response = await fetch(`${this.baseUrl}/api/v1/web4/movement`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(movementData),
    });
    
    if (!response.ok) {
      throw new Error('Failed to create movement');
    }
    
    return await response.json();
  }
}
```

## 🚨 Error Handling

### Error Response Format
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input parameters",
    "details": {
      "field": "address",
      "reason": "Invalid Ethereum address format"
    }
  },
  "timestamp": "2024-09-04T14:00:00Z"
}
```

### Common Error Codes
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `429` - Rate Limit Exceeded
- `500` - Internal Server Error

## 📈 Rate Limiting

### Rate Limits
- **Free Tier**: 100 requests/hour
- **Pro Tier**: 1,000 requests/hour
- **Enterprise**: 10,000 requests/hour

### Rate Limit Headers
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

## 🔒 Security

### Best Practices
1. **Always use HTTPS** for API calls
2. **Store API keys securely** (environment variables)
3. **Validate input** before sending requests
4. **Handle errors gracefully**
5. **Use proper authentication**

### Security Headers
```http
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
```

## 📚 SDKs and Libraries

### Official SDKs
- **Flutter/Dart**: `rechain_vc_lab` package
- **JavaScript/TypeScript**: `@rechain/vc-lab-sdk`
- **Python**: `rechain-vc-lab`
- **Java**: `com.rechain.vclab`

### Community Libraries
- **React**: `react-rechain-vc-lab`
- **Vue**: `vue-rechain-vc-lab`
- **Angular**: `@rechain/angular-vc-lab`

## 🤝 Support

### Getting Help
1. **Documentation**: Check this API documentation
2. **Issues**: Create GitHub issues for bugs
3. **Discussions**: Use GitHub Discussions for questions
4. **Email**: support@rechain.network
5. **Discord**: Join our Discord server

### API Status
- **Status Page**: https://status.rechain.network
- **Uptime**: 99.9%
- **Response Time**: < 200ms average

---

**Last Updated**: 2024-09-04
**API Version**: v1.0.0
**Documentation Version**: 1.0.0
