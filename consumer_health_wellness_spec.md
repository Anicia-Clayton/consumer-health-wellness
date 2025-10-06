# Consumer Health/Wellness × Cloud Security (Simplified)
**One-page spec**

**Goal:**  
Lock down a product-ingredient lookup API with least privilege and guardrails.

**What you’ll build:**  
A secure serverless API that serves mock ingredient safety data.

**AWS (≤5):**  
API Gateway (HTTP), Lambda, DynamoDB (mock ingredient table), IAM (least privilege), KMS (encryption).

---

### **Success metrics**
- No public S3/DynamoDB exposure; all access via API only.  
- IAM policy: least privilege (deny * before allow; resource-scoped).  
- Security scan (Checkov/tfsec) 0 high/critical findings.  

---

### **Deliverables**
- DynamoDB table (partition key: barcode).  
- Lambda handler with input validation + throttling (per-IP rate limit via API GW).  
- IAM role/policies: Lambda can only dynamodb:GetItem on that table.  
- KMS-encrypted env secrets (if any).  
- Security artifacts: tfsec/checkov reports + short “what we hardened” note.  

---

### **2-week sprint**
- **Day 1–2:** Model API contract; seed DynamoDB with 10 sample products.  
- **Day 3–4:** Lambda + API GW; add input validation & error handling.  
- **Day 5:** Lock down IAM; add KMS; enable access logs.  
- **Day 6:** Run tfsec/checkov; fix misconfigs; add WAF (optional).  
- **Day 7–8:** Negative testing (invalid barcodes, bursts); write runbook.  
- **Day 9–10:** Demo; export security scan reports; backlog (Cognito auth, WAF rules, SOC hooks).

