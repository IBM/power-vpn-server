data "ibm_resource_instance" "cos_instance" {
  name              = var.instance_name
  resource_group_id = var.resource_group_id
  service           = "cloud-object-storage"
}

resource "ibm_cos_bucket" "cos_bucket" {
  bucket_name          = var.bucket_name
  resource_instance_id = data.ibm_resource_instance.cos_instance.id
  region_location      = var.bucket_region
  storage_class        = "smart"
}

resource "ibm_cos_bucket_object" "plaintext" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  content         = var.content
  key             = var.key
}

locals {
  bucket_url = format("https://cloud.ibm.com/objectstorage/%s?bucket=%s&bucketRegion=%s&endpoint=s3.%s.cloud-object-storage.appdomain.cloud&paneId=bucket_overview",
    urlencode(data.ibm_resource_instance.cos_instance.crn),
    var.bucket_name,
    var.bucket_region,
    var.bucket_region
  )
}
