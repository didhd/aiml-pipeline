# AIML Pipeline

This project implements an end-to-end AI/ML pipeline using AWS services including Redshift, S3, SageMaker, and API Gateway.

## Project Structure

- `infrastructure/`: Terraform configurations for AWS resources
- `src/`: Source code for data extraction, model training, and API
- `notebooks/`: Jupyter notebooks for model development
- `tests/`: Unit tests for the project

## Setup

1. Install terraform:
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

2. Configure AWS credentials:
   ```
   aws configure
   ```

3. Initialize Terraform:
   ```
   cd infrastructure
   terraform init
   ```

4. Apply Terraform configuration:
   ```
   terraform apply
   ```

5. Once the infrastructure is set up, access SageMaker Studio:
   - Go to the AWS Management Console
   - Navigate to Amazon SageMaker
   - Click on "Studio" in the left sidebar
   - Click on "Open Studio" for your user profile
   - Clone the repository

6. In SageMaker Studio:
   - Open a new notebook
   - Use the provided notebook templates in the `notebooks/` directory to start developing your ML models

## Estimated Costs

The following table provides an estimate of the monthly costs associated with this project. Please note that these are approximate values and actual costs may vary based on usage and AWS pricing changes.

| Resource            | Specification                                                   | Estimated Monthly Cost |
| ------------------- | --------------------------------------------------------------- | ---------------------- |
| Redshift Serverless | 8 RPUs, 100 hours/month                                         | $400                   |
| S3                  | 100 GB storage, 1000 PUT/COPY/POST requests, 10000 GET requests | $3                     |
| SageMaker Studio    | ml.t3.medium instance, 100 hours/month                          | $20                    |
| SageMaker Training  | ml.m5.xlarge, 10 hours/month                                    | $24                    |
| SageMaker Endpoint  | ml.t2.medium, 720 hours/month (always on)                       | $70                    |
| Lambda              | 1 million invocations/month, 128 MB memory, 100ms avg. duration | $0.20                  |
| API Gateway         | 1 million API calls/month                                       | $3.50                  |

**Total Estimated Monthly Cost: $520.70**

### Cost Optimization Tips:

1. Use Redshift Serverless judiciously, pausing when not in use.
2. Optimize S3 storage by implementing lifecycle policies.
3. Shut down SageMaker Studio instances when not in use.
4. Use SageMaker managed spot training for cost-effective model training.
5. Consider using SageMaker serverless inference for infrequent predictions.
6. Implement auto-scaling for SageMaker endpoints based on traffic patterns.
7. Monitor and adjust Lambda function memory and timeout settings.
8. Use AWS Cost Explorer and AWS Budgets to track and manage costs.

Please note that this is a rough estimate and actual costs may vary depending on your specific usage patterns, data volumes, and the complexity of your models. It's recommended to use the [AWS Pricing Calculator](https://calculator.aws/#/) for more precise estimates based on your expected workload.

## Contributing

We welcome contributions to the AIML Pipeline project! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -am 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please make sure to update tests as appropriate and adhere to the [Code of Conduct](CODE_OF_CONDUCT.md).

## Security

Security is of the utmost importance for this project. While this is a demonstration project and not intended for production use, we still follow best practices:

- We use least-privilege permissions in our Terraform configurations
- Sensitive information is never hard-coded and should be managed through AWS Secrets Manager or environment variables
- Regular security audits of dependencies are conducted

If you discover any security issues, please email aws-security@amazon.com instead of using the issue tracker.

For production deployments, always refer to the [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html) Security Pillar for comprehensive security best practices.

## License

This project is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file for details.

The MIT-0 License is a variation of the MIT License that removes the requirement for attribution. This means you can use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software without restrictions, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

For the full license text, refer to the [LICENSE](LICENSE) file in the repository.