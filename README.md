# Title

## Tested with: 

| Environment | Application | Version  |
| ----------------- |-----------|---------|
| WSL2 Ubuntu 20.04 | terraform | v1.1.2  |
| WSL2 Ubuntu 20.04 | ansible-pull | 2.9.6  |
| WSL2 Ubuntu 20.04 | aws-cli | 2.2.12  |

## Initialization How-To:

## Deployment How-To:

Generate a Key-Pair using AWS-CLI:

```bash
aws ec2 create-key-pair --key-name Jenkins-DEMO --query 'KeyMaterial' --output text > Jenkins-DEMO.pem
```

>:warning: if you use a different key name, change the variable "key_name" in the variables.tf file

Change permissions:
```bash
chmod 400 Jenkins-DEMO.pem
```

Move to home folder:
```bash
mv Jenkins-DEMO.pem ~/.ssh/Jenkins-DEMO.pem
```

>:warning: if you choose a different location, change the variable "local_ssh_key" in the variables.tf file

## Debugging / Troubleshooting:

#### **Debugging Tip #1**: 

#### **Known issue #1**: 
 - **Issue**: 
- **Cause**: 
- **Solution**: 

## Author:

- [@jmanzur](https://github.com/JManzur)

## Documentation:

- [EXAMPLE](URL)