# Consumer Health/Wellness × Cloud Security – Minimal AWS Stack
**Goal:** Secure ingredient lookup API with least-privilege IAM and encrypted storage, plus **AWS Config** runtime checks.

## Stack
- API Gateway (HTTP) → Lambda (GET /v1/ingredient?barcode=...)
- DynamoDB (encrypted with KMS CMK); CloudWatch logs
- **AWS Config baseline** (recorder+delivery+managed rules + small conformance pack)

## Deploy (dev)
1) Configure backend in `infra/envs/dev/providers.tf` `backend "s3"`.
2) Build Lambda zip:
   ```bash
   cd infra/modules/api_lambda/package
   zip -r lambda.zip lambda_function.py
   ```
3) Apply:
   ```bash
   cd infra/envs/dev
   terraform init
   terraform apply -auto-approve
   ```
4) Test:
   ```bash
   curl "$API_BASE_URL/v1/ingredient?barcode=000111222333"
   ```

## Security
- Input validation on barcode (11–14 digits)
- KMS CMK for DynamoDB SSE
- IAM resource-scoped to table
- **AWS Config**: S3 SSE, DynamoDB KMS, Lambda no public access, S3 no public read
- tfsec workflow in `.github/workflows/terraform-security-check.yml`
