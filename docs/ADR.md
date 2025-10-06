# Architecture Decision Record (ADR)
## Project: Consumer Health/Wellness × Cloud Security

### ADR-001: Use Serverless Architecture
**Context:** The API requires low maintenance, high scalability, and pay-per-use.  
**Decision:** Use API Gateway + Lambda + DynamoDB.  
**Rationale:** Simplifies scaling and reduces operational overhead.

### ADR-002: Enforce Encryption at Rest
**Context:** Ingredient data could contain health-related info.  
**Decision:** Use DynamoDB SSE with KMS CMK.  
**Rationale:** Protects data from unauthorized physical or logical access.

### ADR-003: Integrate tfsec + AWS Config
**Context:** Compliance enforcement needed during CI/CD and runtime.  
**Decision:** tfsec for IaC scanning; AWS Config for runtime validation.  
**Rationale:** Provides preventive + detective coverage for security.

### ADR-004: Add WAF with OWASP Rules
**Context:** Public API exposed to the internet.  
**Decision:** Use AWS WAF managed rules (OWASP + rate limiting).  
**Rationale:** Prevents injection attacks and brute-force API abuse.
