variable "public_key_path" {
    default = "~/.ssh/id_rsa.pub"
    description = "public key for VM access"
}

variable "vm_size" {
    default = "Standard_B2s"
    description = "VM size"
}

variable "region" {
    default = "East Us"
    description = "Resources' region"
}

# random string to name VM, Storage account, and the multi-cognitive resources with
resource "random_id" "rand_id" {
    byte_length = 3
}