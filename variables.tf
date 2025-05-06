variable "external_id" {
  type = string
  description = "External ID to use along with the secrets sync role"
}

variable "hcp_org_id" {
  type = string
  description= "ID of your HCP organization"
}

variable "hcp_project_id" {
  type = string
  description= "ID of your target HCP project"
}