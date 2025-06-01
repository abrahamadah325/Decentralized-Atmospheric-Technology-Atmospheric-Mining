# Decentralized Atmospheric Technology - Atmospheric Mining

A comprehensive blockchain-based system for managing atmospheric mining operations with built-in verification, environmental monitoring, and regulatory compliance.

## Overview

This project implements a decentralized atmospheric mining platform using Clarity smart contracts on the Stacks blockchain. The system provides end-to-end management of atmospheric resource extraction operations while ensuring environmental protection and regulatory compliance.

## System Architecture

### Core Contracts

1. **Mining Entity Verification** (`mining-entity-verification.clar`)
    - Validates and manages mining entity registrations
    - Handles entity verification and status management
    - Maintains entity licensing and expiration tracking

2. **Extraction Protocol** (`extraction-protocol.clar`)
    - Manages atmospheric resource extraction operations
    - Tracks extraction locations, rates, and progress
    - Coordinates with entity verification for authorization

3. **Environmental Impact** (`environmental-impact.clar`)
    - Monitors environmental effects of mining operations
    - Records atmospheric readings (CO2, pressure, temperature, AQI)
    - Calculates impact scores and compliance status

4. **Resource Distribution** (`resource-distribution.clar`)
    - Handles extracted resource inventory management
    - Facilitates resource transfers between entities
    - Maintains distribution records and audit trails

5. **Regulatory Compliance** (`regulatory-compliance.clar`)
    - Ensures adherence to atmospheric mining regulations
    - Manages violation reporting and resolution
    - Conducts compliance audits and scoring

## Features

### Entity Management
- Entity registration and verification
- License tracking and expiration management
- Status monitoring (pending, verified, suspended, revoked)

### Extraction Operations
- Location-based extraction tracking
- Resource type and rate management
- Operation lifecycle management (active, completed, suspended)

### Environmental Monitoring
- Real-time atmospheric data collection
- Impact score calculation
- Compliance threshold monitoring
- Environmental trend analysis

### Resource Management
- Multi-resource inventory tracking
- Secure resource transfers
- Distribution audit trails
- Balance verification

### Regulatory Oversight
- Violation reporting and tracking
- Compliance scoring system
- Audit scheduling and management
- Status-based operation controls

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js for testing

### Installation

1. Clone the repository
2. Install dependencies
3. Deploy contracts to Stacks testnet/mainnet

### Usage

#### Register a Mining Entity
\`\`\`clarity
(contract-call? .mining-entity-verification register-entity "AtmosMining Corp" "AM-2024-001")
\`\`\`

#### Start Extraction Operation
\`\`\`clarity
(contract-call? .extraction-protocol start-extraction
u1 ;; entity-id
40750000 ;; latitude (40.75° * 1000000)
-73980000 ;; longitude (-73.98° * 1000000)
u10000 ;; altitude in meters
"oxygen" ;; resource type
u100 ;; extraction rate
u1000 ;; duration in blocks
)
\`\`\`

#### Record Environmental Data
\`\`\`clarity
(contract-call? .environmental-impact record-reading
u1 ;; operation-id
u415 ;; CO2 level (ppm)
u101325 ;; pressure (Pa)
15 ;; temperature (°C)
u45 ;; air quality index
)
\`\`\`

## Testing

Run the test suite using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment and initialization
- Entity registration and verification
- Extraction operation management
- Environmental monitoring
- Resource distribution
- Regulatory compliance

## Environmental Considerations

The system implements strict environmental monitoring with:
- Maximum allowable CO2 level changes (5%)
- Pressure variation limits (3%)
- Temperature change thresholds (2%)
- Air quality index monitoring
- Automated compliance scoring

## Regulatory Framework

Built-in compliance features include:
- Violation severity classification (Low, Medium, High, Critical)
- Automated compliance scoring
- Regular audit scheduling
- Status-based operation controls
- Resolution tracking

## Security Features

- Owner-only administrative functions
- Entity verification requirements
- Resource balance validation
- Operation authorization checks
- Immutable audit trails

## Contributing

1. Fork the repository
2. Create a feature branch
3. Implement changes with tests
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For technical support or questions, please open an issue in the repository.
