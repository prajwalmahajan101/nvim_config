-- Terraform snippets: resource/module/provider/output/variable scaffolds.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("tf_resource", fmt([[
resource "{type}" "{name}" {{
  {body}
}}
]], { type = i(1, "aws_s3_bucket"), name = i(2, "main"), body = i(3, "bucket = \"my-bucket\"") })),

  s("tf_module", fmt([[
module "{name}" {{
  source = "{src}"

  {body}
}}
]], { name = i(1, "vpc"), src = i(2, "terraform-aws-modules/vpc/aws"), body = i(3, "name = \"main\"") })),

  s("tf_provider_aws", fmt([[
terraform {{
  required_providers {{
    aws = {{
      source  = "hashicorp/aws"
      version = "{ver}"
    }}
  }}
  required_version = ">= 1.5.0"
}}

provider "aws" {{
  region = "{region}"
}}
]], { ver = i(1, "~> 5.0"), region = i(2, "us-east-1") })),

  s("tf_output", fmt([[
output "{name}" {{
  description = "{desc}"
  value       = {value}
  {sensitive}
}}
]], { name = i(1, "id"), desc = i(2, "..."), value = i(3, "aws_s3_bucket.main.id"), sensitive = i(4, "") })),

  s("tf_var", fmt([[
variable "{name}" {{
  description = "{desc}"
  type        = {type}
  default     = {default}
}}
]], { name = i(1, "region"), desc = i(2, "AWS region"), type = i(3, "string"), default = i(4, "\"us-east-1\"") })),
}
