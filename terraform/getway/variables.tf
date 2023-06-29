# variables.tf
# Input variable definitions

variable "project_id" {
  description = "project name"
  type        = string
}

variable "credentials_file" {
  description = "憑証檔案"
  type        = string
}

variable "region" {
  description = "國家"
  type        = string
}

variable "zone" {
  description = "地區"
  type        = string
}
variable "dbversion" {
  description = "資料庫版本"
  type        = string
}

variable "container_names" {
  description = "Create nginx containers with these names"
  type        = list(string)
  default     = ["nginx-1", "nginx-2", "nginx-3"]
}

variable "container_ports" {
  description = "Create nginx containers with these ports"
  type        = list(number)
  default     = [8081, 8082, 8083]
}
