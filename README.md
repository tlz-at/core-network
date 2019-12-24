Core Network Account
====================
The core network account will provide centralized network transit between AWS accounts utilizing the AWS Transit Gateway.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account\_id | The ID of the working account | string | - | yes |
| azs\_primary | A list of availability zones in the region | list | `<list>` | no |
| azs\_secondary | A list of availability zones in the region | list | `<list>` | no |
| sse\_algorithm | The server-side encryption algorithm to use. Valid values are AES256 and aws:kms | string | `AES256` | no |
| tags | A map of tags to add to all resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| account\_alias | The alias name for the account |
| account\_id | Account ID |
| baseline\_version | Version of the baseline module |
