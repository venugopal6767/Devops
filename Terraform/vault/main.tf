provider "aws" {
    region = "us-east-1"
}

provider "vault" {
    address = "http://54.166.121.219:8200"
    skip_child_token = true
    auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id = "6789c5b0-6372-1d88-eae6-cc26598e297c"
      secret_id = "1b5e60e0-e0b9-088a-cac7-e86665a8c645"
    }
  }    
}

data "vault_kv_secret_v2" "venu" {
  mount = "kv"
  name = "venu"
}


resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.venu.data["test-secret"]
  }
}