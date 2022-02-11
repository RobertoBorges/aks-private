variable "name" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "registration_enabled" {
    type    = bool
    default = false
}

variable "linked_vnets" {
    type = map
    default = {}
}

variable "a_records" {
    type    = map
    default = {}
}

variable "aaaa_records" {
    type    = map
    default = {}
}

variable "cname_records" {
    type    = map
    default = {}
}

variable "mx_records" {
    type    = map
    default = {}
}

variable "ptr_records" {
    type    = map
    default = {}
}

variable "srv_records" {
    type    = map
    default = {}
}

variable "txt_records" {
    type    = map
    default = {}
}

variable "tags" {
    type    = map
    default = {}
}