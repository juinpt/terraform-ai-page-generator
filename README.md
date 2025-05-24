
# Terraform AI Page Generator

This project automates the provisioning of an AI-powered web page generator on AWS using Terraform. It leverages OpenAI's API to generate content dynamically and deploys the application on EC2 instances.

## Features

- **Infrastructure as Code**: Utilizes Terraform to define and provision AWS resources.
- **Modular Design**: Employs Terraform modules for reusable and maintainable code.
- **AI Integration**: Integrates OpenAI's API for dynamic content generation.
- **Automated Deployment**: Automates the setup of EC2 instances with necessary configurations.
- **Scalable Deployment**: Control the number of EC2 instances using the `instance_count` variable.
- **High Availability**: Automatically deploys each instance in a different Availability Zone (AZ) within the same AWS region.

## Prerequisites

Before deploying the infrastructure, ensure you have the following:

- **Ubuntu**: This setup requires an Ubuntu-based EC2 AMI.
- **AWS CLI**: Installed and configured with appropriate credentials.
- **Terraform**: Installed on your local machine.
- **OpenAI API Key**: An active API key from OpenAI.

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/juinpt/terraform-ai-page-generator.git
cd terraform-ai-page-generator
```

### 2. Configure OpenAI API Key

Set your OpenAI API key as an environment variable:

```bash
export TF_VARS_openai_api_key="your_openai_api_key_here"
```

Or add it to a `.tfvars` file:

```hcl
openai_api_key = "your_openai_api_key_here"
```

### 3. Configure Instance Count (Optional)

To control how many EC2 instances are deployed, set the `instance_count` variable:

```hcl
instance_count = 3
```

Each instance will be deployed in a distinct Availability Zone within the region for improved fault tolerance.

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Review and Apply the Terraform Plan

```bash
terraform plan
terraform apply
```

Confirm the action when prompted.

## Project Structure

```
terraform-ai-page-generator/
├── ai-page-generator-dockerimage
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
├── LICENSE
├── main.tf
├── modules
│   └── ec2-instance
│       ├── files
│       │   └── user_data.sh.tmpl
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── providers.tf
├── README.md
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
└── variables.tf
```

## AWS Resources Provisioned

- **EC2 Instances**: Virtual servers to host the AI page generator application. Each instance is placed in a separate Availability Zone.
- **Security Group**: Defines inbound and outbound rules for the EC2 instances.
- **IAM Role (if applicable)**: Grants necessary permissions to the EC2 instances.

## Application Deployment

Each EC2 instance is configured to:

- Install necessary dependencies (e.g., Python, required libraries).
- Deploy the AI page generator application.
- Expose the application on a specified port (e.g., port 80).

Ensure your security group allows inbound traffic on the chosen application port.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- [OpenAI](https://openai.com/) for providing the API used in content generation.
- [Terraform](https://www.terraform.io/) by HashiCorp for infrastructure provisioning.
