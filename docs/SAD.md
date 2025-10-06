# Solutions Architecture Document (SAD)
## Project: Consumer Health/Wellness × Cloud Security

### 1. Overview
A secure ingredient lookup API designed to protect consumer data and product transparency.  
Implements least-privilege IAM, encryption at rest, and runtime compliance monitoring.

### 2. Goals
- Provide ingredient lookup service via HTTPS API.
- Ensure no public data exposure.
- Maintain 0 critical findings in tfsec and AWS Config.
- Support runtime security validation with AWS Config and WAF.

### 3. Architecture Summary
**Pattern:** Serverless REST API  
**Stack:** API Gateway → Lambda → DynamoDB (encrypted)  
**Security Layers:**
- *Preventive:* tfsec scanning, IAM least privilege, KMS encryption
- *Detective:* AWS Config compliance monitoring
- *Responsive:* WAF (rate limiting + OWASP protection)

### 4. Data Flow
1. User queries ingredient by barcode.
2. API Gateway routes to Lambda.
3. Lambda validates input, retrieves record from DynamoDB (encrypted via KMS CMK).
4. Logs sent to CloudWatch.
5. Config + tfsec validate ongoing compliance.

### 5. Key AWS Services
| Layer | Service | Purpose |
|-------|----------|----------|
| Compute | Lambda | Execute business logic |
| Storage | DynamoDB (KMS) | Secure ingredient data |
| Security | IAM | Enforce least privilege |
| Compliance | AWS Config | Continuous configuration audit |
| Protection | WAF | Web protection & rate limiting |

### 6. Security & Compliance
- AWS Config Conformance Pack: CIS AWS Foundations Benchmark
- WAF with OWASP rule set
- tfsec scanning in CI/CD
- IAM denies before allow (resource-scoped)

### 7. Future Enhancements
- Add Cognito authentication for registered users.
- Extend WAF rules for geo restrictions.
- Integrate AWS Security Hub for aggregated findings.
