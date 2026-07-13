# Implementation Notes

## Verified Configuration

- Region used during the implementation: Europe (Ireland)
- Operating system: Amazon Linux 2023
- Web server: Nginx
- Auto Scaling capacity used for testing: desired 1, minimum 1, maximum 2
- Load balancer listener: HTTP port 80
- Target health check: HTTP path `/`
- CloudWatch logs: Nginx access and error logs
- Scaling validation: CPU load generated with `stress-ng`

## Important Limitation

The verified deployment was manual. The deployment package was stored in Amazon S3, downloaded on EC2, extracted, and copied to the Nginx web root. Newly launched replacement instances therefore require deployment automation before this design can be considered production-ready.

## Recommended Production Improvements

- AWS CodeDeploy or CodePipeline for repeatable deployments
- HTTPS using ACM
- Route 53 custom domain
- SNS alerting
- Private subnets for EC2
- Least-privilege IAM policies
- Automated bootstrap or immutable AMI strategy
