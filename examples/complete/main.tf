provider "aws" {
  region = "eu-west-1"
}

module "tgw" {
  source = "../../"

  name            = "my-tgw"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  enable_auto_accept_shared_attachments = true // When "true" there is no need for RAM resources

  //  tgw_routes =

  tags = {
    Purpose = "tgw-complete-example"
  }
}
