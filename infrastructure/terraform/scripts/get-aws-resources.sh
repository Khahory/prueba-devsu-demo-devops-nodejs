#!/bin/bash

# ===== SCRIPT TO GET AWS RESOURCES =====
# This script helps you get VPC and subnet IDs from your current AWS account
# so you can update the variables in locals.tf

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

show_banner() {
    echo
    print_message $BLUE "=========================================="
    print_message $BLUE "  GET AWS RESOURCES FOR EKS"
    print_message $BLUE "=========================================="
    echo
}

check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        print_message $RED "❌ AWS CLI is not installed. Please install it first."
        exit 1
    fi
    print_message $GREEN "✅ AWS CLI is installed"
}

check_aws_auth() {
    if ! aws sts get-caller-identity &> /dev/null; then
        print_message $RED "❌ You are not authenticated to AWS. Run 'aws configure' or configure your credentials."
        exit 1
    fi
    print_message $GREEN "✅ AWS authentication verified"
}

get_account_info() {
    print_message $YELLOW "📋 Current AWS account information:"
    
    CURRENT_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
    CURRENT_USER_ARN=$(aws sts get-caller-identity --query 'Arn' --output text)
    CURRENT_REGION=$(aws configure get region || echo "us-east-1")
    
    print_message $GREEN "✅ AWS Account: $CURRENT_ACCOUNT_ID"
    print_message $GREEN "✅ User: $CURRENT_USER_ARN"
    print_message $GREEN "✅ Region: $CURRENT_REGION"
    echo
}

list_vpcs() {
    print_message $YELLOW "🌐 Listing available VPCs:"
    echo
    
    aws ec2 describe-vpcs \
        --query 'Vpcs[*].[VpcId,Tags[?Key==`Name`].Value|[0],CidrBlock,State]' \
        --output table
    
    echo
    print_message $YELLOW "💡 Select the VPC ID you want to use for EKS"
    echo
}

list_subnets() {
    print_message $YELLOW "🔗 Listing available subnets:"
    echo
    
    aws ec2 describe-subnets \
        --query 'Subnets[*].[SubnetId,Tags[?Key==`Name`].Value|[0],AvailabilityZone,CidrBlock,State]' \
        --output table
    
    echo
    print_message $YELLOW "💡 Select at least 2 subnet IDs (preferably in different AZs)"
    echo
}

show_specific_commands() {
    print_message $BLUE "🔧 Useful commands to get specific resources:"
    echo
    
    print_message $YELLOW "To get VPCs with more details:"
    echo "aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,Tags[?Key==\`Name\`].Value|[0],CidrBlock,State]' --output table"
    echo
    
    print_message $YELLOW "To get subnets from a specific VPC:"
    echo "aws ec2 describe-subnets --filters \"Name=vpc-id,Values=vpc-xxxxxxxxx\" --query 'Subnets[*].[SubnetId,Tags[?Key==\`Name\`].Value|[0],AvailabilityZone,CidrBlock,State]' --output table"
    echo
    
    print_message $YELLOW "To get only public subnets:"
    echo "aws ec2 describe-subnets --filters \"Name=map-public-ip-on-launch,Values=true\" --query 'Subnets[*].[SubnetId,Tags[?Key==\`Name\`].Value|[0],AvailabilityZone,CidrBlock,State]' --output table"
    echo
    
    print_message $YELLOW "To get only private subnets:"
    echo "aws ec2 describe-subnets --filters \"Name=map-public-ip-on-launch,Values=false\" --query 'Subnets[*].[SubnetId,Tags[?Key==\`Name\`].Value|[0],AvailabilityZone,CidrBlock,State]' --output table"
    echo
}

show_update_instructions() {
    print_message $BLUE "📝 Instructions to update locals.tf:"
    echo
    
    print_message $YELLOW "1. Open the file: infrastructure/terraform/modules/aws-eks/locals.tf"
    echo
    
    print_message $YELLOW "2. Update the following lines:"
    echo "   - Line 12: Change vpc_id to your VPC ID"
    echo "   - Lines 18-19: Change subnet_ids to your subnet IDs"
    echo
    
    print_message $YELLOW "3. Update example:"
    echo "   vpc_id = \"vpc-your-vpc-id-here\""
    echo "   subnet_ids = [\"subnet-your-subnet-1\", \"subnet-your-subnet-2\"]"
    echo
}

main() {
    show_banner
    check_aws_cli
    check_aws_auth
    get_account_info
    list_vpcs
    list_subnets
    show_specific_commands
    show_update_instructions
}

main "$@"